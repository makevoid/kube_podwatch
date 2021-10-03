require "bundler/setup"
Bundler.require :default

require_relative "../lib/slack_webhook"
include SlackWebhook
