class RestsController < ApplicationController
  def index
  	render text: '', status: :moved_permanently
  end

  def create
  	render text: '', status: :moved_permanently
  end
end
