class RevisionsController < ApplicationController
  def index
    @revisions = Article.find(params[:article_id]).revisions
  end

  def new
    article = Article.find(params[:article_id])
    if !article.revisions.empty?
      @previous_revision = article.revisions.last
    end
  end

  def create
    @article = Article.find(params[:article_id])

    @revision = Revision.new(revision_params)
    @revision.editor_id = current_user.id
    @revision.article_id = @article.id
    @revision.previous_revision_id = @article.revisions.ids.last

    if @revision.save
      redirect_to @article
    else
      @errors = @revision.errors.full_messages
      render "new"
    end
  end

  def show
    @revision = Revision.find(params[:id])
  end

  private

  def revision_params
    params.require(:revision).permit(:body)
  end
end