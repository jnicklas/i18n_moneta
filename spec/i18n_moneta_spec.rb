require 'rubygems'
require 'stringio'
require 'spec'
require 'spec/autorun'
require File.dirname(__FILE__) + '/../lib/i18n_moneta'
require 'moneta/memory'

describe I18nMoneta do
  
  before do
    @moneta = Moneta::Memory.new
    @backend = I18nMoneta.new(@moneta)
    I18n.backend = @backend
  end

  it "should get a translation from the backend" do
    @backend['sv.foo.bar'] = 'Monkey'
    I18n.locale = :sv
    I18n.t('foo.bar').should == 'Monkey'
  end
  
  it "should store translations" do
    @backend.store_translations(:sv, :foo => { :bar => 'Monkey', :quog => 'Ape' }, :baz => 'Gorilla')
    @backend['sv.foo.bar'].should == 'Monkey'
    @backend['sv.foo.quog'].should == 'Ape'
    @backend['sv.baz'].should == 'Gorilla'
    I18n.locale = :sv
    I18n.t('foo.bar').should == 'Monkey'
    I18n.t('foo.quog').should == 'Ape'
    I18n.t('baz').should == 'Gorilla'
  end
  
end
