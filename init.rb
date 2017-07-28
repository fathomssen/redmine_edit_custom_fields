# Edit Custom Fields plugin for Redmine
# 
# Copyright (c) 2015 Frederick Thomssen
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

Redmine::Plugin.register :redmine_edit_custom_fields do
  name 'Redmine Edit Custom Fields plugin'
  author 'Frederick Thomssen'
  description 'Redmine plugin to allow users editing custom fields for their project'
  version '0.0.5'
  requires_redmine '3.4'
  url 'https://github.com/fathomssen/redmine_edit_custom_fields'
  author_url 'http://www.frederick-thomssen.de'

  project_module :edit_custom_fields do
    permission :edit_custom_fields, { edit_custom_fields_settings: [ :update ] }, require: :member
  end
end

Rails.configuration.to_prepare do
  # Load patches for Redmine
  require_dependency File.join( File.dirname(File.realpath(__FILE__)), 'lib', 'custom_field_patch' )
  require_dependency File.join( File.dirname(File.realpath(__FILE__)), 'lib', 'projects_helper_patch' )

  # Load application helper
  ::EditCustomFieldsHelper.tap do |mod|
    ActionView::Base.send :include, mod unless ActionView::Base.include?(mod)
  end
end

# Load hooks
require_dependency File.join( File.dirname(File.realpath(__FILE__)), 'lib', 'edit_custom_fields_hook' )
