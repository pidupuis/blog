---
title: Django database tips
date: 2017-04-18T12:00:00.000Z
categories: Debug
tags:
    - django
    - python
    - debug
    - tips
---


When dealing with frameworks like Django, one can easily get stuck into using easy options without controlling anything. In many cases, that would be okay. But sometimes you'll need to dig a little bit further to better understand what happens and to get back the control of your code. Here are some easy-to-use tips to help you debug and optimize your Django code.

<!-- more -->

# Investigate your queries using `connection.queries`

Django's ORM gives you a lot of features to manipulate your models, but sometimes it fails in term of performance. That is only by looking at the final executed queries that you'll understand how you can optimize your request or whether using a raw query would be more appropriate. The following code shows how to extract information about a query: the number of generated queries and their run rime.

```python
from django.db import connection
from demo.models import Item

class DemoViewPage(View):
    def get(self, request):
        print(Item.objects.all().count())

        print("[DEBUG] {} queries executed in {}ms".format(
            len(connection.queries),
            sum(float(q.get("time")) for q in connection.queries),
        ))
```

# Rollback your queries using `transaction.atomic`

Another tip, which is more of a must-use good practice, shows you how to turn off the autocommit in order to fully decide when you want your queries to be executed. This is not always necessary, but when a process is complex and can fail before the end, you have to be able to decide whether you want to revert any database modifications which occurred during the process.

In the following example, we have three loops creating 10 items each. We raise an exception in the middle of the second batch so we expect to have 25 items at the end. However, the second loop was wrapped inside an atomic transaction. This means that we don't want any item from the second batch if there is an error during the process of this batch. As we can see at the end, the second batch was entirely rollbacked, leading to 20 items created.

Only the code wrapped into the atomic transaction is rollbacked. The other parts work as usual, with an autocommit.

```python
from django.db import connection, transaction
from demo.models import Item

class DemoViewPage(View):
    @transaction.atomic
    def get(self, request):
        # Create 10 items
        for _ in range(0, 10):
            Item.objects.create()

        # Try to create 10 more items but fail after the fifth
        try:
            with transaction.atomic():
                for i in range(0, 10):
                    Item.objects.create()
                    if i == 4:
                        raise Exception('Fail!')
        except:
            print('Rollback!')

        # Create 10 more items
        for _ in range(0, 10):
            Item.objects.create()

        # 20 items were created, not 25 nor 30...
        print(Item.objects.all().count())
```


Hope you liked this tutorial!
