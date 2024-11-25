-- Imports
local Expect = require "cc.expect"

local Table = require "mb.algorithm.table"

--- Redstone wrapper.
---@class RsDevice
---@field private _controller table Wrapped redstone controller.
---@field private _side string Side of the redstone controller to use.
---@field private _inverted boolean If set redstone signal will be inverted.
local RsDevice = {}
RsDevice.__index = RsDevice

--- Constructor
---@param name string? Wrapped redstone controller name. Passing nil results in the computer being used.
---@param side string Side of the redstone controller to use.
---@param params table? Optional parameters.
function RsDevice.new(name, side, params)
  Expect.expect(1, name, "string", "nil")
  Expect.expect(2, side, "string")
  Expect.expect(3, params, "table", "nil")
  
  if params then
    Expect.field(params, "inverted", "boolean", "nil")
  end
  
  local self = setmetatable({}, RsDevice)
  
  local params = params or {}
  
  if name then
    self._controller = peripheral.wrap(name)
    if type == nil or not peripheral.hasType(self._controller, "redstoneIntegrator") then
      error("invalid controller: " .. name, 2)
    end
  else
    self._controller = redstone
  end
  
  if not Table.contains_value(redstone.getSides(), side) then
    error("invalid side: " .. side, 2)
  end
  
  self._side = side
  self._inverted = self.inverted or false
  
  return self
end

-- Check if the output is active.
function RsDevice:is_on()
  local state = self._controller.getOutput(self._side)
  if self._inverted then
    return not state
  else
    return state
  end
end

-- Set the output active.
function RsDevice:set_on()
  self._controller.setOutput(self._side, not self._inverted)
end

-- Set the output inactive.
function RsDevice:set_off()
  self._controller.setOutput(self._side, self._inverted)
end

-- Toggle the output.
function RsDevice:toggle()
  self._controller.setOutput(self._size, not self:is_open())
end

return RsDevice
