$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'i18n'
require 'moneta'

class I18nMoneta < I18n::Backend::Simple
  VERSION = '0.0.1'
  
  attr_reader :moneta
  
  def initialize(moneta)
    @moneta = moneta
  end
  
  def []=(key, value)
    @moneta[key] = value
  end
  
  def [](key)
    @moneta[key]
  end

  # Accepts a list of paths to translation files. Loads translations from
  # plain Ruby (*.rb) or YAML files (*.yml). See #load_rb and #load_yml
  # for details.
  def load_translations(*filenames); end

  # Stores translations for the given locale in memory.
  # This uses a deep merge for the translations hash, so existing
  # translations will be overwritten by new ones only at the deepest
  # level of the hash.
  def store_translations(locale, data)
    flatten_data(locale => data).each do |key, value|
      self[key] = value
    end
  end

  def initialized?
    true
  end

  # Returns an array of locales for which translations are available
  # ignoring the reserved translation meta data key :i18n.
  def available_locales
    []
  end

  def reload!
  end

  def init_translations
  end

  def translations
    # We can't traverse arrays in moneta, so we don't know what translations
    # there are until we try to look them up
    {}
  end

  # Looks up a translation from the translations hash. Returns nil if
  # eiher key is nil, or locale, scope or key do not exist as a key in the
  # nested translations hash. Splits keys or scopes containing dots
  # into multiple keys, i.e. <tt>currency.format</tt> is regarded the same as
  # <tt>%w(currency format)</tt>.
  def lookup(locale, key, scope = [], separator = nil)
    return unless key
    keys = I18n.send(:normalize_translation_keys, locale, key, scope)
    @moneta[keys.join('.')]
  end

private

  def flatten_data(data, prefix=nil)
    result = {}
    if data.is_a?(Hash)
      data.each do |key, value|
        result.merge!(flatten_data(value, [prefix, key].compact.join('.')))
      end
    else
      result[prefix] = data
    end
    result
  end

end