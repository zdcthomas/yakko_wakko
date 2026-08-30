# No offline Wikipedia, deliberately

`opt` runs `kiwix-serve` to host an offline Wiktionary, and Kiwix reads
Wikipedia ZIM files just as happily. We do not install one. This is a choice,
not an oversight.

## Why

The modes exist to remove rabbit holes, and an encyclopedia is the most
effective rabbit hole ever built. Serving it locally removes the network, not
the next link. The same reasoning removed a delay-gated blocklist earlier in
the design: temptation that stays reachable stays expensive.

Wiktionary survives because a word lookup ends. You look up a word, you get a
definition, and you return to the sentence you were writing. An article does
not end.

## The plan, if this reverses

The decision is cheap to reverse, and it should reverse if the user starts
searching for articles while writing, or starts writing essays that need
research.

1. Download `wikipedia_en_all_maxi` — every article with images, roughly
   100GB. `/nix` had 1.5T free when this was written.
2. Add the ZIM to the existing `kiwix-serve` service. No new service.
3. Reach it from the `making` and `open` browsers at `localhost:8080`.
4. Keep it out of `writing`. If `writing` ever needs it, install the Kiwix
   desktop application there rather than a text browser. The desktop app opens
   ZIM files only and cannot reach the web. A text browser can wander.

The ZIM is also the first place to reclaim disk. It is one large file, and
deleting it breaks nothing else.
