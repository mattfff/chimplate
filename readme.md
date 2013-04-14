Chimplate - Easy MailChimp user template updating
=================================================

What is it?
-----------

I've found myself doing a lot of template editing for clients lately,
and though Mailchimp's excellent in-browser editing tools make it easy
to get up and running, they don't provide any of the tools required for
managing a large number of templates with lots of common elements, managing
revisions, etc, etc.

There are tons of tools available to make this process easier, chiefly
git. I wanted to have all of the templates stored in a git repo so I
could track changes to each file, generate patches to apply to similar
templates, etc, but the process of making local modifications and then
copying and pasting into Mailchimp's template window was a major pain.
As a result, I would get lazy and make edits directly in the editor
window, and then version tracking goes out the window.

Solution?
---------

I thought a tool to automatically push and pull templates from local
text files into Mailchimp templates in would be a good
solution, so Chimplate was born. I also added live update support
similar to `compass --watch`, so that Mailchimp will be updated on the fly
as you change files on your disk. Now you can use your favorite local
editor, save the files, and see the live changes in Mailchimp, all super
fast!

Usage
=====

Install chimplate via `gem install chimplate`.

Chimplate relies on the mailchimp gem, which requires Ruby 1.9+, so
you'll need a more up to date ruby than ships on OSX, unfortunately.
Homebrew can help you with that, or rvm or rbenv.

Next, make a project folder you'd like to work from. This folder should
be dedicated to only the templates for a single MC account, because the
folder-wide config file will store that account's API key.

In that folder, run `chimplate setup --api_key YOUR_API_KEY --name
"Project Name"`

This will write a .chimplate file to that directory which stores that
info.

Now:

1. To retrieve existing templates on that account, run `chimplate pull`.
   That will pull down all of the user templates in that account.
2. Make a change in one or more files, and run `chimplate push`. This
   will update the templates in your account.
3. Run `chimplate watch`. This will watch for changes to the html files
   in this directory, and update Mailchimp on the fly as they are
updated.

All of the files are stored with a specific file format, as follows:
template_id-template_name.html. So if you have a template that has an ID
in mailchimp of 12345, and the name is "My Cool Template", when you run
a `chimplate pull`, you will get a file named
`12345-My_Cool_Template.html`. Ideally you shouldn't change these
filenames manually, as that could cause issues syncing up with the same
file in MailChimp. Most importantly, don't change the format, or the ID,
as that's the primary identifier between MailChimp and your local copy.

New Files
---------

Now that you know about the format, you can create a totally new
template locally and push it to MailChimp. To do so:

1. Create a new html file with your template content in the same folder,
   with a filename in the format of: "new-My_Template_Name.html". The
"new" flags it as a new template.
2. Run `chimplate push`. This will create a new template in MailChimp
   with the name of "My Template Name". It will also rename your local
copy to contain the ID of the new template, so it will look like
"12345-My_Template_Name.html". From that point on, you can edit it as
normal.

Note: When making new files the watch option doesn't work. So if you
want to create a new file, kill the watch process via Ctrl+C, make the
new file, run `chimplate push`, and then re-start the `chimplate watch`
process to resume pushing your changes on the fly back to Mailchimp.

Diff
----
If you want to see what's different between your local copy and what's
in Mailchimp, just run `chimplate diff`. This will diff all of the
current local files against mailchimp.

If you just want to diff one file, pass the full filename: `chimplate
diff --filename 12345-My_Template.html`.

Note: Diff support requires a working diff. If you're a Windows user
you'll need working diff, as described on the Diffy page:
https://github.com/samg/diffy.

Gotchas
-------

Once you start editing your templates this way, it's important to avoid
using Mailchimp's editor in your browser. If you make changes there, and
then don't pull them with Chimplate before pushing your local copies
again, you could overwrite the changes you made directly in Mailchimp!
There's no function in Chimplate (or in Mailchimp) for checking
modification times, so you could lose work if you aren't rigorous about
doing it all in one place (or at least all via a git repo to centralize
version control). You have been warned!

TODO
----

1. Write some tests.
2. Better error handling. At this point if you mess up a filename so that
it doesn't match the expected format Chimplate will probably give you a nasty
stack trace and run home to mommy. Sorry! I hope to fix this soon...
3. Provide some sort of support for template deletion. At this point I'm
happy leaving it to the Mailchimp UI, since accidental deletion would be
a bummer.
