class ErrorsController < ApplicationController
  def not_found
    @code = 404
    @message = 'Page not found'
    render :error, status: 404
  end

  def internal_server
    @code = 500
    @message = 'Internal server error'
    render :error, status: 500
  end

  def unprocessable
    @code = 422
    @message = 'Unprocessable Content'
    render :error, status: 422
  end

  def unacceptable
    @code = 406
    @message = 'Not Acceptable'
    render :error, status: 406
  end
end
