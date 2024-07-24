# Frequently Asked Questions, Co-dfns and Otherwise

**How do I get started with APL?**

This is probably the question that I get asked the most. I have even created a blog post about it. Best start there:

https://www.sacrideo.us/getting-started-with-apl/

You can also check out Dyalog's getting started page:

https://www.dyalog.com/getting-started.htm

**What does the Co-dfns compiler do/buy me?**

The Co-dfns compiler is designed to enable you as an APL programmer to use Dyalog APL and write standard APL code, and then relatively seamlessly compile that code for better performance on vector machines, particularly high-performance GPUs.

**Will Co-dfns compile my code?**

That depends. Please check out the [limitations](https://github.com/Co-dfns/Co-dfns/blob/master/docs/MANUAL.md#known-limitations) file for information about what Co-dfns does not support right now. If you have some code that Co-dfns cannot currently compile, that you'd really like it to compile, talk to me and let's see if we can't make that happen.

Keep in mind that some code that people write will simply not perform well on a GPU, even if the compiler did compile that code.

**How is Co-dfns licensed?**

The Co-dfns compiler, and any objects that are compiled by Co-dfns, are dual-licensed. You can use the compiled objects and the compiler itself in accordance with the terms of the AGPL if that works for you. Additionally, if you have a Dyalog APL license, then you may also use the Co-dfns compiler and objects compiled by the Co-dfns compiler under the terms of your license agreement with Dyalog, as if Co-dfns were an integral component of Dyalog APL.

**How is Co-dfns released?**

Co-dfns uses a "release when it's ready" semantic versioning model. We release freely and without any set cycle or cadence, and we attempt to release whenever we can improve the system, rather than holding on to releases. We will not shy away from breaking backwards compatibility, and we will freely increment the major version number when appropriate. Please take this into consideration and make sure to plan accordingly.

**Will Co-dfns be self-hosting?**

Yes. It is not currently, but it will be. We are getting very close to this goal now.

**Will Co-dfns work standalone without Dyalog APL?**

Co-dfns is not intended to replace working within the Dyalog APL development environment. However, Co-dfns is designed to allow for use cases where the interpreter may not be a good fit. The intent has always been to keep the compiler small, and leverage the existing features of the interpreter where they make sense to avoid duplicate work.

That being said, Co-dfns compiled modules have always been designed to easily integrate into a variety of application frameworks. It is possible to, for instance, embed Co-dfns compiled modules into C and Java programs, provided that you comply with the license terms. Compiled Co-dfns modules are capable of operating independent of the Dyalog APL interpreter, and thus, you do not need the interpreter in order to run a Co-dfns compiled module if you don't want to do so.

This allows you to use APL in places where the interpreter might otherwise be too heavyweight to use, such as when shipping code that would benefit from a core APL calculation embedded into it for performance, but which cannot, for one reason or another, ship the entire interpreter.

**Can I integrate Co-dfns modules with language X?**

See above. Chances are, yes, provided that it has a suitable C FFI.

**But I don't want to use Dyalog APL...**

Why not? Dyalog has proven to be an innovative, supportive, and committed company that supports a great deal of good work throughout the world. Moreover, they actively fund the Co-dfns project and promote the further research into improving APL.

They have extremely competitive and fair licensing policies, are open-source friendly, and their system includes some of the widest array of useful, practical functionality around. Quite frankly, why would you *not* make use of all of those goodies?

**But Dyalog APL isn't open source!**

Dyalog would be more than happy to release Dyalog APL as an open source product if the open-source community demonstrated their willingness to support and maintain the continued growth and profitability of the company. Translation: Dyalog as a company, I believe, is deeply concerned about ensuring that the people that work for them receive just compensation for the work that they do, and they care about promoting APL; neither of these things can be done in the current economic climate of open-source.

If the open source community demonstrated that they were willing to pay for the growth of the Dyalog APL system and those who work on it, I'm sure things would look different.

The Co-dfns compiler is Free Software, but releasing Co-dfns under terms that many of the open-source community would expect, would instantly mean that the Co-dfns compiler would cease to exist in any meaningful way, because I couldn't afford to work on it anymore.

Let's not bite the hand that feeds us, and even better, as an open-source community, let's find ways of better making our own food instead of relying on the charity of others to feed us.

**How do I use the compiler?**

See the [docs](../docs) directory in the Co-dfns repository. If you are still confused, please contact me so that I can improve the documentation.

**Why is your code so unreadable?**

See [here](https://www.youtube.com/watch?v=gcUWTa16Jc0&feature=youtu.be), and also [here](https://news.ycombinator.com/item?id=13638086), and [here](https://news.ycombinator.com/item?id=13797797), and [here](https://news.ycombinator.com/item?id=13565743).

**APL is unreadable, hard to write!**

Chances are, you're a programmer if you're saying that:

https://youtu.be/v7Mt0GYHU9A

**Do I need a discrete GPU to use Co-dfns?**

No, you can also use it with standard Intel CPUs or anything with OpenCL support. The best performance is still with GPUs, though.

