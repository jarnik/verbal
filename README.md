# Verbal ![](exampleData/verbal_64.png)
Verbal is a node-based conversation tool. I could not find a simple, flexible, open conversation tool, so I made one myself. It is meant to be a simple tool for gamejams and smaller projects.


### How it works ###

Use the editor to create the conversation and export it to a JSON file like this:
```json
[
   {"actions":["What the heck?! You scared me to death!"],"id":0,"links":[1,2,-1],"x":55,"y":78},
   {"conds":["My name is Mancomb Seepwood and I want to be a salesman!"],"id":1,"x":58,"y":256},
   {"conds":["I am looking for a nearest treasure. Seen any lately?"],"id":2,"x":58,"y":457},
   {"conds":["Can you teach me how to use a sword? "],"id":3,"x":297,"y":256}
]
```
Then load the JSON into your game using the library (see the examples) or just interpret the data any way you need.

### Library platforms ###

Supported: OpenFL

Planned: HaxeFlixel, Unity, ? LOVE, ? GameMaker

Conversation tree example:

![Tree Conversation Example](exampleData/screenshot_treeExample.png)

### Editor (alpha) ###

![Verbal editor](exampleData/screenshot_verbalEdit.png)

Get it here (*Linux*, *Windows*, *Flash*):
* http://itch.io
* http://gamejolt.io
