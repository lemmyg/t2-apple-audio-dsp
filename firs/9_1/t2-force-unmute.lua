-- Force T2 raw audio devices to be unmuted at full volume
-- This ensures the DSP has proper input/output levels
-- Based on Asahi Linux's asahi-limit-volume.lua

local config = ... or {}

seen_devices = {}

function parseParam(param, id)
  local route = param:parse()
  if route.pod_type == "Object" and route.object_id == id then
    return route.properties
  else
    return nil
  end
end

function handleDevice(device)
  for p in device:iterate_params("Route") do
    local route = parseParam(p, "Route")
    if not route then
      goto skip_route
    end

    -- Handle Speakers only (no mic config for 9_1)
    local desc = route.description
    if desc ~= "Speakers" and desc ~= "Speaker" then
      goto skip_route
    end

    local pr = route.props
    if pr and pr.properties then
      pr = pr.properties
    end

    if pr and (pr.channelVolumes == nil or pr.channelVolumes[1] ~= 1.0 or pr.mute == true) then
      local props = {
        "Spa:Pod:Object:Param:Props", "Route",
        mute = false,
        channelVolumes = Pod.Array({ "Spa:Float", 1.0 })
      }
      local param = Pod.Object {
        "Spa:Pod:Object:Param:Route", "Route",
        index = route.index,
        device = route.device,
        props = Pod.Object(props),
      }
      Log.info("Forcing route to unmuted full volume: " .. tostring(desc))
      device:set_param("Route", param)
    end
    ::skip_route::
  end
end

om = ObjectManager {
  Interest {
    type = "device",
    Constraint { "alsa.card_name", "equals", "Apple T2 Audio", type = "pw" },
  }
}

om:connect("objects-changed", function (om)
  local new_seen_devices = {}
  for device in om:iterate() do
    if not seen_devices[device["bound-id"]] then
      seen_devices[device["bound-id"]] = true
      device:connect("params-changed", handleDevice)
      handleDevice(device)
    end
    new_seen_devices[device["bound-id"]] = true
  end
  seen_devices = new_seen_devices
end)

om:activate()

