# Infinity-AntiCheat [Deprecation Warning]
Infinity-AntiCheat was initially just a concept system used to test the functionality of the Infinity framework (Base and ECS)
However, as i've watched other projects grow, I often find sinking hours into Infinity AntiCheat development leaves me with the sinking feeling that I am re-inventing the wheel.

As we know, you should never trust the client. But what is it that the client has such a good hold of? Their character, that is where the majority of server-replicated exploits come from.
And so Infinity's job would be dedicated to monitoring and handling that character which is running on the client. 

The issue with this is, there's a really, really good project called `chickynoid` and. Well it asserts server authority over the players character,  somewhat removing the client
from handling physics, collisions and manipulative behaviour, there would be no reason to have an anticheat hogging up resources in the background. 

And primarily due to this, I find that this AntiCheat is a deprecated piece of technology, it could of been something good. But I lost the motivation to continue as I saw
chickynoid become so much more performant, secure and reliable. 

Games with consistant 1-10k players use it as a base. This was enough to explain to me that chickynoid would be a much better system to implement. 

---

Aye, congradulations chickynoid, the system you work behind is unbelievable, I believe i'll move over to integrating chickynoid into my own projects instead of sinking hours into a
project like this.

Thats all, thanks :smile:
