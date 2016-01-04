# Guidelines for frontmatter metadata

Article templates have the following frontmatter metadata:

- title: Title of article
- author: First Last &lt;first.last@rackspace.com>
- date: yyyy-mm-dd
- featured: true
- permalink: docs/article-type/slug-of-article/
- description: Article description with keywords
- docker-versions:
 - x.x.x
- topics:
  - Key terms used for categorization and filtering  

Following are some guidelines for populating the frontmatter metadata of your articles.

## Title
Use the following guidelines when creating titles for your articles:

- Create **succinct, meaningful, descriptive titles** that do not rely on body text or other titles for their meaning (that are, in other words, independent of context). Customers should be able to tell from a title whether the information in the article is relevant to their needs. Avoid ambiguous one-word titles, such as "Overview." Place the most important words first in a title.

- Use **sentence-style capitalization**. That is, capitalize only the first word of the title or heading, plus any proper nouns, proper adjectives, and terms that are always capitalized, such as some acronyms and abbreviations.

- Begin titles of task-tutorial or task topics with an imperative verb. Example: **Install Docker on Mac OS X**

- Begin titles of concept-tutorial, 101-tutorial, and reference topics with a noun. Example: **Containers 101**

- Begin troubleshooting topics with a noun or gerund, usually. Example: **Error running interactive Docker shell on Windows** or **Troubleshooting the Docker Toolbox set up on Windows**

- If a title contains a special character, such as a colon, enclose the title with single quotation marks. For example: `title: 'Container ecosystem: Mesos versus OpenStack'`

## Author
Enter the first name and last name of the main person responsible for the creation of the content, followed by the author's Rackspace email address enclosed in angle brackets.

Currently, only one author can be listed.

## Date
Use the format shown in the template, which is the ISO 8601 format and should be acceptable for international audiences: ***yyyy-mm-dd***. For example, for October 1, 2015, use **2015-10-01**.

## Featured

Optional. Set this value to `true` to mark the document as featured. This will typically result in the file being displayed before any documents that are not featured. If the document should _not_ be featured, set this value to `false` or omit it altogether.

## Permalink
Create the permalink for your article by using the following format:

docs/*article-type*/*slug-of-article*/

- *article-type* is the name of the GitHub folder in which the article lives, without the leading underscore. Example: **tutorials** or **best-practices**

- *slug-of-article* is the title of the article, minus any connecting articles and helper words, hyphenated, and all lowercase. The “slug” should  contain only alphanumeric characters and hypens; no underscores. Example: for the title “Run Wordpress in Docker Swarm,” the slug would be **run-wordpress-docker-swarm**

- Always include a trailing slash, and never include a slash preceding **docs**.

**Examples:**

- **docs/concepts/containers-101/**
- **docs/references/error-running-interactive-docker-shell-windows/**

## Description

The description should provide a succinct and clear overview of the article, using as many important keywords as possible to describe the main point of the content. The description is displayed in search results, so in addition to the title, this is the text that will tell the user whether this is information they want. Use the following guidelines:

- Ensure that the description makes sense when displayed as stand-alone text.

- Limit the description to one or two brief sentences. The length restriction is about 160 characters.

- Do not just repeat the title of the article! You can, however, draw content from your introduction or other key parts of the article.

- Use as many keywords as possible. Use words that you anticipate might be associated with a user’s query.

- Be persuasive. Use action words to draw the user in and pique their interest. For example, start the description with an action phrase like “Learn how to” or “Learn about” or “Get the information you need.”

- For tutorials and tasks, explain what the user accomplishes by completing the task or tutorial (the purpose of the task or tutorial). You might include who performs the task, why it is necessary, when to perform it, or where to perform it. For example:

  - Learn how Docker deploys your applications to containers and interacts with the Rackspace Container Service to help you build, ship, and run your applications anywhere

  - Get the information you need to install Docker on Mac OS X and set up your environment to start using containers for your applications

- For a troubleshooting article, briefly state the issue. For example:

  - Resolve issues related to Docker setup on Windows, such as conflicting apps, Docker Toolbox issues, nested virtualization, and incorrect environment setup

## Docker versions

List the version of Docker that you used when creating the article. This should be the version the steps were tested against, so that a user using that version will get the same results. If you know that the content is compatible with more than one version, list all of the compatible versions.  

Currently, Docker versions include up to three digits: *x*.*x*.*x*

Example:

- 1.8.2

**Note:** Some best practice, conceptual, or other articles might not be asscoiated with a version of Docker. If this field does not apply to your content, omit the field entirely from your article's metadata.

## Topics

*Topics* are used to categorize and filter the content for users, and might eventually be used as a mechanism to suggest articles to users as they perform a task in the control panel.  

Using standard topics is a key to successful categorization and filtering of information for users.

[Standard list of terms and further guidelines TBD]
