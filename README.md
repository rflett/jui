# JUI

The fronted for the jui application

## Getting Started

To generate the automated files run the script inside the `scripts` folder. This will auto-generate JSON serialisation
code for you for models that have the correct decorator on them

### Automation
To automate the generation process a bit adding the following script:
```
#!/bin/sh

./scripts/generate-code
```
into 2 separate files name `post-checkout` and `post-merge` inside your .git/hooks folder.

This will automatically regenerate the models for you every time you switch branches / merge code.