module Todotxt
  PRIORITY_REGEX = /^\(([A-Z])\) /
  PROJECT_REGEX  = /(\+\w+)/
  CONTEXT_REGEX  = /(@\w+)/
  DATE_REGEX     = /^(\([A-Z]\) )?(x )?((\d{4}-)(\d{1,2}-)(\d{1,2}))\s?/
  DONE_REGEX     = /^(\([A-Z]\) )?x /
end
