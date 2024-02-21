async function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

let body = `{
  "at": 1,
  "device": {
    "devicetype": 2,
    "geo": {
      "city": "Moline",
      "country": "US",
      "lat": 41.49,
      "lon": -90.5,
      "metro": "682",
      "region": "IL",
      "zip": "61265"
    },
    "ip": "173.28.249.175",
    "js": 0,
    "language": "EN",
    "make": "Mozilla",
    "model": "Firefox",
    "os": "Desktop",
    "osv": "",
    "ua": "Mozilla/5.0 (Windows; Windows NT 6.1; WOW64; en-US) Gecko/20100101 Firefox/48.9"
  },
  "ext": {
    "ssl": 1
  },
  "id": "55d9dc0b-9bdb-46c4-a975-15af29a22c64",
  "imp": [
    {
      "banner": {
        "battr": [],
        "h": 250,
        "pos": 1,
        "topframe": 1,
        "w": 300
      },
      "bidfloor": 0.18,
      "ext": {
        "appnexus": {
          "placement_id": 31898679
        }
      },
      "id": "55209419ec0f422e8507f667b3418a24",
      "instl": 0,
      "secure": 1,
      "tagid": "main_left_lobby"
    }
  ],
  "regs": {
    "ext": {
      "gdpr": 0
    }
  },
  "site": {
    "cat": [
      ""
    ],
    "domain": "minehut.com",
    "id": "1188886",
    "keywords": "deal=1710024",
    "name": "Minehut",
    "page": "https://minehut.com/",
    "publisher": {
      "id": ""
    },
    "ref": ""
  },
  "test": 0,
  "tmax": 350,
  "user": {
    "ext": null
  }
}`;
let succ: Array<Response> = [];

for (let index = 0; index < 10_000; index++) {
  let resp = await fetch(
    "http://slg-useast.adnxs.com/openrtb2?member_id=13931",
    {
      method: "POST",
      headers: {
        "content-type": "application/json",
        "x-openrtb-version": "2.5",
      },
      body,
    }
  );
  if (resp.status != 204) {
    succ.push(resp);
    console.log(resp);
    console.log(resp.text());
  }
  console.log(index);
  sleep(50);
}

console.log(succ);
