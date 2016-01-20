#!/usr/bin/env ruby
# encoding: UTF-8
require 'yaml'
require 'rexml/document'
require 'fileutils'

class PlistWriter
  PLIST_STUB_DOC = <<-STUB
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0"></plist>
  STUB

  def initialize(root_object)
    @document = REXML::Document.new(PLIST_STUB_DOC)
    @current_node = @document.root
    process(root_object)
  end

  def build_element(name, text = nil)
    @current_node.add_element(name.to_s).tap do |new_node|
      new_node.add_text(text.to_s.dup) unless text.nil?
      next unless block_given?
      _current_node = @current_node
      @current_node = new_node
      yield
      @current_node = _current_node
    end
  end

  def process(object)
    case object
    when Hash
      build_element(:dict) do
        object.each {|k, v| build_element(:key, k); process(v)}
      end
    when Array
      build_element(:array) do
        object.each {|e| process(e) }
      end
    when String
      build_element(:string, object)
    when Integer
      build_element(:integer, object)
    when Float
      build_element(:real, object)
    when Date
      build_element(:date, object.to_time(:utc).iso8601)
    when Time, DateTime
      build_element(:date, object.to_time.utc.iso8601)
    when FalseClass
      build_element(:false)
    when TrueClass
      build_element(:true)
    else
      raise "Unexpected object of class #{object.class.name}"
    end
  end

  def to_s
    "".tap do |s|
      f = REXML::Formatters::Pretty.new(indentation=4)
      f.compact = true
      f.write(@document, s)
    end
  end
end

AVIAN_BUNDLE_DIR = File.expand_path('~/Library/Application Support/Avian/Bundles')
BUNDLE_DIR = File.expand_path('./JSNext-tmbundle')
PREFERENCES_DIR = File.join(BUNDLE_DIR, 'Preferences')
SYNTAXES_DIR = File.join(BUNDLE_DIR, 'Syntaxes')
THEMES_DIR = File.join(BUNDLE_DIR, 'Themes')

desc 'Generate TextMate bundle'
task :generate_bundle do
  FileUtils.rm_rf(BUNDLE_DIR)
  FileUtils.mkdir_p([
    PREFERENCES_DIR,
    SYNTAXES_DIR,
    THEMES_DIR,
  ])
  FileUtils.cp('./info.plist', "#{BUNDLE_DIR}/info.plist")

  Dir.glob('./*.tm*.yaml') do |yaml_file|
    dest_file = File.basename(yaml_file, '.yaml')
    dest_path = case dest_file
      when /.tmPreferences$/ then PREFERENCES_DIR
      when /.tmLanguage$/ then SYNTAXES_DIR
      when /.tmTheme$/ then THEMES_DIR
    end
    dest = File.join(dest_path, dest_file)

    puts "Writing #{dest}"
    File.open(File.join(dest_path, dest_file), File::CREAT|File::TRUNC|File::RDWR, 0644) do |f|
      f.write(PlistWriter.new(YAML::load_file(yaml_file)))
    end
  end
end

desc 'Symlink bundle to Avian/Bundles'
task :symlink do
  FileUtils.mkdir_p(AVIAN_BUNDLE_DIR)
  FileUtils.ln_s(BUNDLE_DIR, AVIAN_BUNDLE_DIR)
end

task :default => [:generate_bundle]