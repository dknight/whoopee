<!-- Description: Chain of Responsibility is a design pattern used where a request is passed through a series of handlers (like a queue). Each handler checks if it can handle the request. If it can, it processes it; if not, it passes the request to the next handler in the queue. -->

tags: lua design-patterns

# Chain of Responsibility

Chain of Responsibility is a design pattern used where a request is passed through a series of handlers
(like a [queue](/post/queue.html)). Each handler checks if it can handle the request. If it can, it processes it;
if not, it passes the request to the next handler in the queue.

![Chain of Responsibility Scheme](/assets/img/dp-chain-of-responsibility.svg)

One of the best examples of a chain of responsibility design pattern is payment systems. Let's imagine you need to pay
online, and you have three payment systems in your account in order of priority: MasterCard, Visa, and PayPal. If 
MasterCard does not have enough money, the next responsible system will be Visa. If also on Visa, there is not enough 
money; PayPal will be the last fallback. The pattern should go to the next item until it exists; if there are no more 
online wallets, an error message will be printed that you do not have enough money.

## Account class

I keep the account class basic; it has only two fields: name and balance, and two important methods:
`pay` and `setNext`.

- `setNext`: sets the next (following) account in the chain;
- `pay`: first we try to pay from the first account; if there is not enough money, we try next and so on. It is very similar to recursion.

```lua
---@class Account
---@field public name string
---@field public balance number
---@field public following? Account
local Account = {}
Account.__index = Account

---@return Account
---@param name string
---@param balance number
function Account:new(name, balance)
	local t = {
		name = name,
		balance = balance,
		following = nil,
	}
	return setmetatable(t, self)
end

---@param amount number
---@return boolean
function Account:canPay(amount)
	return self.balance >= amount
end

---@param amount number
function Account:pay(amount)
	if self:canPay(amount) then
		print("Paid $" .. amount .. " using " .. self.name)
	elseif self.following ~= nil then
		print("not enough money on " .. self.name)
		self.following:pay(amount)
	else
		print("not enough money on all accounts")
	end
end

---@param account Account
function Account:setNext(account)
	self.following = account
end

return Account
```

## Account usage

We will use each account in the chain until one has enough money. If no any account has the required amount, the common
message is that there is not enough money in all accounts. In this case, it will be paid with PayPal.

```lua
local Account = require("Account")

local master = Account:new("Master Card", 100)
local visa = Account:new("Visa", 500)
local paypal = Account:new("PayPal", 800)
master:setNext(visa)
visa:setNext(paypal)

master:pay(750)
--[[
not enough money on Master Card
not enough money on Visa
Paid $759 using PayPal
--]]
```