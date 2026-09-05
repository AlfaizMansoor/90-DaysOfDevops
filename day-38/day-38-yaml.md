# Day 38 – YAML Basics
## TASK-1
1. I create **"person.yaml"** that describes me with:
    - name:
    - role:
    - experience:
    - learning:

#### Verify: Run `cat person.yaml` - does it look clean? No tabs?
* **"YES!"** it looks clean and there is no tabs in that file **"person.yaml"**

## TASK-2
1. I added to **"person.yaml"**
    - tools — a list of 5 DevOps tools you know or are 
    - learning
    - hobbies — a list using the inline format [item1 item2]

#### What are the two ways to write a list in YAML?
1. **Multi-line** - This is the most common format. Each item in the list is placed on a new line at the same indentation level e.g.

- fruits:
     - Apple
     - Orange
     - Mango

2. **Singlr-line** - This format is a more compact, JSON-like syntax. All items are written on a single line, enclosed in square brackets [], and separated by commas e.g.

- fruits: [Apple, Orange, Mango]

## TASK-3
1. I create a **"server.yaml"** that describes a server:
    - server with nested keys: `name`, `ip`, `port`
    - database with nested keys: `host`, `name`, credentials (nested further: `user`, `password`)

#### Verify: Try adding a tab instead of spaces — what happens when you validate it?
* It failed because of wrong indent tab use 4 spaces where in **.yaml** use only 2 spaces.

## TASK-4
1. In server.yaml, i add a startup_script field using:
    - The | block style (preserves newlines)
    - The > fold style (folds into one line)

#### When would you use | vs >?

* **|** 
    - It keeps line breaks: Every newline you type stays in the final text, 
    - **Use case:** Great for code snippets, markdown, or text where exact formatting matters.

* **>**
    - Changes newlines to spaces: It turns line breaks into single spaces so the text flows as one paragraph 
    - Use case: Great for long sentences that you want to wrap nicely in your raw code file without breaking the actual output string.

## TASK-5 
1. I used an online validator
2. I validate both my YAML files
3. Intentionally break the indentation — what error do you get?
    - **"Nested mappings are not allowed in compact mappings at line 17, column 12"**
    - **"Implicit keys need to be on a single line at line 17, column 12"**
4. Fix it and validate again
    - **"Valid YAML!"**

## TASK-6
```yaml
#### Block 1 - correct
name: devops
tools:
  - docker
  - kubernetes
```

```yaml
# Block 2 - broken
name: devops
tools:
- docker
  - kubernetes  
```

* I read both blocks and i found vulnerabilities in second block that is:-
    - **indent of line 4 "- kubernetes" is wrong, two extra spaces in list**
