# Working agreements

## Never commit unless explicitly asked

Do not run `git commit` unless my most recent message contains the word
"commit" and explicitly asks you to make one. No exceptions:

- Not after finishing a task, however complete or well-verified it is.
- Not to "checkpoint" work in progress.
- Not because an earlier message in the conversation authorised a commit —
  that authorisation covered that commit only, not later ones.
- Not to fix or amend a commit I have asked you to undo.

Leave finished work as uncommitted changes in the working tree. That is how I
review what you did — I read the diff. Committing it takes the review away
from me.

The same applies to `git push`, `git rebase`, `git reset` against committed
history, and anything else that rewrites or publishes history: ask first.
