#!/usr/bin/env python3
"""Turn the GCIDE source files into a pyglossary tabfile.

GCIDE ships as CIDE.A .. CIDE.Z, plain files in a bespoke SGML-ish markup with
no build system of its own. Debian's dict-gcide carries its own perl to do this
job; this is the same job in one file.

An entry is a <p>...</p> block. Its headwords are the <ent> tags, and there can
be several -- inflections and alternative spellings share one block. Several
blocks can also share a headword, one per sense, so blocks are merged by
headword rather than emitted one per block.

Output is `headword \t definition`, with literal newlines escaped as \\n, which
is the tabfile format pyglossary reads.
"""

import html
import re
import sys
from pathlib import Path

# GCIDE writes its line breaks as `<br/` followed by a newline, with no closing
# bracket. Left alone, the tag stripper below runs past it and swallows the
# real tag that follows. Normalise it before anything else looks at the text.
BR = re.compile(r"<br/\s*")

# <pr> is pronunciation in a respelling scheme that means nothing as plain
# text, and it contains unbalanced markup like `<?/` that would otherwise eat
# the tags after it. <hw> is the headword again, carrying syllable and accent
# marks; <ent> already holds the clean form. Drop both elements whole.
DROP_ELEMENTS = re.compile(
    r"<(pr|hw|ety|source|mark|amorph|wordforms)>.*?</\1>", re.DOTALL
)
BLOCK = re.compile(r"<p>(.*?)</p>", re.DOTALL)
ENT = re.compile(r"<ent>(.*?)</ent>", re.DOTALL)
TAG = re.compile(r"<[^>]*>")
BRACKETED_EMPTY = re.compile(r"\[\s*\]")
WHITESPACE = re.compile(r"[ \t\r\n]+")


def clean(block: str) -> str:
    text = BR.sub(" ", block)
    text = DROP_ELEMENTS.sub(" ", text)
    text = ENT.sub(" ", text)
    text = TAG.sub(" ", text)
    text = html.unescape(text)
    text = BRACKETED_EMPTY.sub(" ", text)
    text = WHITESPACE.sub(" ", text)
    return text.strip(" ,;")


def main() -> int:
    source = Path(sys.argv[1])
    files = sorted(source.glob("CIDE.*"))
    if not files:
        print(f"no CIDE.* files under {source}", file=sys.stderr)
        return 1

    entries: dict[str, list[str]] = {}
    order: list[str] = []

    for path in files:
        # GCIDE is Latin-1. A handful of bytes are invalid even for that, and
        # one bad byte should not lose the file.
        raw = path.read_text(encoding="latin-1", errors="replace")
        for block in BLOCK.findall(raw):
            headwords = [html.unescape(e).strip() for e in ENT.findall(block)]
            headwords = [h for h in headwords if h]
            if not headwords:
                continue
            body = clean(block)
            if not body:
                continue
            for headword in headwords:
                if headword not in entries:
                    entries[headword] = []
                    order.append(headword)
                entries[headword].append(body)

    out = sys.stdout
    for headword in order:
        senses = entries[headword]
        if len(senses) == 1:
            definition = senses[0]
        else:
            definition = "\n".join(
                f"{n}. {sense}" for n, sense in enumerate(senses, 1)
            )
        definition = definition.replace("\\", "\\\\").replace("\n", "\\n")
        headword = headword.replace("\t", " ")
        out.write(f"{headword}\t{definition}\n")

    print(f"{len(order)} headwords", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
