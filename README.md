# TFL Bus API Demo

Playing around with the [Transport for London Unified API].

Goal:
- Find bus stops near a point
- Click on a bus stop to see departure information

## Get the list of transport modes

```
curl https://api.tfl.gov.uk/StopPoint/Meta/Modes | jq

[
  {
    "$type": "Tfl.Api.Presentation.Entities.Mode, Tfl.Api.Presentation.Entities",
    "isTflService": true,
    "isFarePaying": true,
    "isScheduledService": true,
    "modeName": "bus"
  },
  ...
]
```

The only part of this I need is the string "bus" - that was easy.

## Get the list of stop point types

```
curl https://api.tfl.gov.uk/StopPoint/meta/stoptypes | jq
```

There's a lot. Let's filter for bus

```
curl https://api.tfl.gov.uk/StopPoint/meta/stoptypes | jq | grep -i bus

  "NaptanBusCoachStation",
  "NaptanBusWayPoint",
  "NaptanOnstreetBusCoachStopCluster",
  "NaptanOnstreetBusCoachStopPair",
  "NaptanPrivateBusCoachTram",
  "NaptanPublicBusCoachTram",
```

Let's try "NaptanBusWayPoint"

## Get a list of bus stops near a location

- Find a location in London using Google Maps. This is the MoJ:

```
https://www.google.com/maps/place/Crown+Prosecution+Service/@51.5000182,-0.1347679,18.12z/data=!4m13!1m7!3m6!1s0x47d8a00baf21de75:0x52963a5addd52a99!2sLondon,+UK!3b1!8m2!3d51.5072178!4d-0.1275862!3m4!1s0x487604ad27e9798f:0x30d95a1d96fb9489!8m2!3d51.4997698!4d-0.1348891
```

```
curl https://api.tfl.gov.uk/StopPoint/?lat=51.5000182&lon=-0.1347679&stopTypes=NaptanBusWayPoint&radius=1000&modes=bus | jq
```

Returns an empty list - that's not right. Maybe stop type is wrong.

```
curl https://api.tfl.gov.uk/StopPoint/?lat=51.5000182&lon=-0.1347679&stopTypes=NaptanPublicBusCoachTram&radius=250&modes=bus | jq
```

That looks better, but there's way more information than we need.


[Transport for London Unified API]: https://api.tfl.gov.uk
