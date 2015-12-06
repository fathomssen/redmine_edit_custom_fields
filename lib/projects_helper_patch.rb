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

require_dependency 'projects_helper'

module EditCustomFields
  module ProjectsHelperPatch
    extend ActiveSupport::Concern

    included do
      unloadable
      alias_method_chain :project_settings_tabs, :edit_custom_fields_settings_tab
    end

    def project_settings_tabs_with_edit_custom_fields_settings_tab
      tabs = project_settings_tabs_without_edit_custom_fields_settings_tab

      if User.current.allowed_to?(:edit_custom_fields, @project) &&
	 @project.module_enabled?(:edit_custom_fields)
        tabs << {
          name: 'edit_custom_fields',
          action: :edit_custom_fields,
          partial: 'edit_custom_fields_settings/form',
          label: :'edit_custom_fields.label_settings' }
      end

      tabs
    end
  end
end

EditCustomFields::ProjectsHelperPatch.tap do |mod|
  ProjectsHelper.send :include, mod unless ProjectsHelper.include?(mod)
end
