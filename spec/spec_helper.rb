require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'action_view/helpers/capture_helper'
require 'action_view/helpers/tag_helper'

include  ActionView::Helpers::TagHelper

require 'bbcode'

RSpec.configure do |config|
  # some (optional) config here
end