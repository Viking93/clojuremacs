# clojuremacs
Customizes the default emacs for a better and pleasant look.

clojuremacs enhances the default emacs experience and is customized for clojure development. This configuration shows you real power
of emacs of what it can really do and to what extend you can customize Emacs. It is useful for both newcomers and powerusers of the clojure and Emacs.

#Prerequisites
Your ```~/.lein/profiles.clj``` should have the following stuff if you are not using **cider-jack-in**:

``` 
{:user {:plugins [[cider/cider-nrepl "0.12.0"] 
                  [refactor-nrepl "2.2.0"]]}} 
```

#Running
Copy or replace the init.el file in the ```~/.emacs.d/``` directory.

#Running Emacs in terminal

```export TERM=xterm-256color```

Add this to your ```.bashrc``` file and source it and start Emacs again.

#Getting started with clojure
To learn how to customize Emacs there are links in the references section. If you want to become an awesome clojure programmer 
get started with the following guide [Brave Clojure](http://www.braveclojure.com/).

#References
1. A beginner tutorial for Emacs for lisp http://tuhdo.github.io/emacs-tutor3.html
2. Basic stuff from http://aaronbedra.com/emacs.d/
3. List of packages to be installed from https://github.com/ghoseb/dotemacs

#Future Work
Use cask 

#Bugs & Improvements
Bug reports and suggestions for improvements are always welcome. GitHub pull requests are even better! :-)

