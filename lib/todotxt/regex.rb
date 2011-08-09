module Todotxt
  PRIORITY_REGEX = /^\(([A-Z])\) /
  PROJECT_REGEX  = /(\+\w+)/
  CONTEXT_REGEX  = /(@\w+)/
  DONE_REGEX     = /^(\([A-Z]\) )?x /
end
