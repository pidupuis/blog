---
title: Django database tips
date: 2017-02-12 12:19:59
categories: Debug
tags:
    - django
    - python
    - debug
    - tips
---


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
        items = Item.objects.all()
        print(items.count())
```
