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

```
curl https://api.tfl.gov.uk/StopPoint/?lat=51.5000182&lon=-0.1347679&stopTypes=NaptanBusWayPoint&radius=1000&modes=bus | jq
```

Returns an empty list - that's not right. Maybe stop type is wrong.

```
curl https://api.tfl.gov.uk/StopPoint/?lat=51.5000182&lon=-0.1347679&stopTypes=NaptanPublicBusCoachTram&radius=250&modes=bus | jq
```

That looks better.

For the rest of the story, see the commit log for this repo.

## Deploying to Heroku

```
heroku create tfl-bus-api-demo
heroku stack:set container
git push heroku main
```


[Transport for London Unified API]: https://api.tfl.gov.uk
