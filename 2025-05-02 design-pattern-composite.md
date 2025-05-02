<!-- Description: The Composite pattern is a structural design pattern that enables you to organize objects into tree-like hierarchies and treat both individual objects and groups of objects uniformly.-->

tags: lua design-patterns

# Composite

The Composite pattern is a structural design pattern that allows you to organize objects into tree-like hierarchies and
treat both individual objects and groups of objects uniformly. This means that simple objects (leaves) and groups of
objects (composites)should have the **same interface**.

Usually such a pattern is not used in Lua, but it is an invaluable pattern to understand generally.

![Composite Scheme](/assets/img/dp-composite.svg)

## Employee class

The `Employee` class contains three properties: `name`, `position`, and `salary`, along with a method called
`getSalary()`. This method serves as a crucial shared interface for retrieving an employee's salary. It plays an
important role in the Composite pattern, which also relies on the `getSalary()` method as a common interface.

```lua
---@class Employee
---@field private name string
---@field private positon string
---@field private salary number
local Employee = {}
Employee.__index = Employee

---@param name string
---@param position string
---@param salary number
---@return Employee
function Employee:new(name, position, salary)
	local t = {
		name = name,
		position = position,
		salary = salary,
	}
	return setmetatable(t, self)
end

---@return number
function Employee:getSalary()
	return self.salary
end

return Employee
```

## ExternalConsultant class

This class is very similar to the `Employee` class, except that it does not have `position` property. However, it implements the same interface, specifically the `Employee:getSalary()` method.

```lua
---@class ExtenalConsultant
---@field private name string
---@field private salary number
local ExtenalConsultant = {}
ExtenalConsultant.__index = ExtenalConsultant

---@param name string
---@param salary number
---@return ExtenalConsultant
function ExtenalConsultant:new(name, salary)
	local t = {
		name = name,
		salary = salary,
	}
	return setmetatable(t, self)
end

---@return number
function ExtenalConsultant:getSalary()
	return self.salary
end

return ExtenalConsultant
```

## Composite class

```lua
---@class Composite
---@field private employees Employee[]
local Composite = {}
Composite.__index = Composite

---@return Composite
function Composite:new()
	local t = {
		employees = {},
	}
	return setmetatable(t, self)
end

function Composite:add(employee)
	table.insert(self.employees, employee)
end

---@return number
function Composite:getSalary()
	local sum = 0
	for _, e in pairs(self.employees) do
		sum = sum + e:getSalary()
	end
	return sum
end
```

## Composite usage

```lua
local composite = Composite:new()
composite:add(Employee:new("John Doe", "CEO", 7000))
composite:add(Employee:new("Mari Liis", "Manger", 4000))
composite:add(Employee:new("Bill Bull", "Manger", 4000))
composite:add(Employee:new("Arthur King", "Clerk", 3500))
composite:add(Employee:new("Paul Artreides", "Clerk", 3400))
composite:add(Employee:new("Sam Ash", "Clerk", 3500))
composite:add(Employee:new("Marieh Kochi", "Clerk", 3200))
composite:add(ExtenalConsultant:new("Abdull Marchi", "Clerk", 2000))
composite:add(ExtenalConsultant:new("Mister X", "Clerk", 1900))

print("Total salaries: " .. composite:getSalary()) --> Total salaries: 32500
```