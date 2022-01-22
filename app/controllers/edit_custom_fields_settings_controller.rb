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

class EditCustomFieldsSettingsController < ApplicationController
  unloadable

  before_action :find_project_by_project_id
  before_action :authorize
  before_action :find_custom_field

  helper :custom_fields

  def update
    @custom_field.safe_attributes = params[:custom_field]
    if @custom_field.save
      call_hook(:controller_custom_fields_edit_after_save, :params => params, :custom_field => @custom_field)
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          # redirect_back_or_default edit_custom_field_path(@custom_field)
          redirect_to :controller => 'projects', :action => 'settings', :id => @project, :tab => 'edit_custom_fields'
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 422 }
      end
    end
  end

  def find_custom_field
    @custom_field = CustomField.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
