module Todotxt
  PRIORITY_REGEX = /^\(([A-Z])\) /.freeze
  PROJECT_REGEX  = /(\+\w+)/.freeze
  CONTEXT_REGEX  = /(@\w+)/.freeze
  DATE_REGEX     = /^(\([A-Z]\) )?(x )?((\d{4}-)(\d{1,2}-)(\d{1,2}))\s?/.freeze
  DONE_REGEX     = /^(\([A-Z]\) )?x /.freeze
end
