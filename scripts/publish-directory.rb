#!/usr/bin/env ruby
# frozen_string_literal: true

# Copies the public columns out of the private research spreadsheet so the
# committed file never carries organizer names, notes, sources, or status.
#
#   ruby scripts/publish-directory.rb

require "csv"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
SOURCE = File.join(ROOT, "_private", "orgs.csv")
DEST = File.join(ROOT, "_data", "orgs.csv")
PUBLIC_COLUMNS = %w[name region twitter bluesky website].freeze

ALIASES = {
  "name" => %w[name],
  "region" => %w[region country_region country],
  "twitter" => %w[twitter x_handle x],
  "bluesky" => %w[bluesky bluesky_handle],
  "website" => %w[website]
}.freeze

def known(value)
  text = value.to_s.strip
  return "" if text.empty?

  probe = text.downcase
  return "" if probe.include?("tbd") || probe.include?("not found") || probe == "verify"

  text
end

def first_handle(value)
  known(value).split(/[|,;]/).map(&:strip).reject(&:empty?).first
end

def public_region(value)
  known(value).sub(/\s*\(verify\)\s*$/i, "")
end

def blank_to_nil(value)
  text = value.to_s
  text.empty? ? nil : text
end

def lookup(row, public_name)
  ALIASES.fetch(public_name).each do |column|
    return row[column] if row.headers.include?(column)
  end
  ""
end

unless File.exist?(SOURCE)
  warn "Missing #{SOURCE}"
  warn "Copy your research spreadsheet there (it is gitignored), then rerun."
  exit 1
end

def read_table(path)
  data = File.binread(path)
  text = data.force_encoding("UTF-8")
  text = data.force_encoding("Windows-1252").encode("UTF-8") unless text.valid_encoding?
  CSV.parse(text, headers: true)
end

rows = read_table(SOURCE).filter_map do |row|
  name = known(lookup(row, "name"))
  next if name.empty?

  {
    "name" => name,
    "region" => blank_to_nil(public_region(lookup(row, "region"))),
    "twitter" => blank_to_nil(first_handle(lookup(row, "twitter"))),
    "bluesky" => blank_to_nil(first_handle(lookup(row, "bluesky"))),
    "website" => blank_to_nil(known(lookup(row, "website")))
  }
end

FileUtils.mkdir_p(File.dirname(DEST))
CSV.open(DEST, "w", encoding: "UTF-8", write_headers: true, headers: PUBLIC_COLUMNS) do |csv|
  rows.each { |row| csv << PUBLIC_COLUMNS.map { |column| row[column] } }
end

puts "Wrote #{rows.length} listings to #{DEST}"
