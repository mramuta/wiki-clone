require 'rails_helper'

describe ArticlesController do
  let!(:user) { User.create(username: 'a', password: 'b', role: 'user') }
  let!(:article) { Article.create!(title: "Article", author_id: user.id, status: "unpublished") }

  describe "GET #show" do
    it "responds with status code 200" do
      get :show, params: { id: article.id }
      expect(response).to have_http_status 200
    end

    it "renders the :show template" do
      get :show, params: { id: article.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "responds with status code 200" do
      get :new
      expect(response).to have_http_status 200
    end

    it "renders the :new template" do
      get :new
      expect(response).to render_template(:new)
    end

  describe "POST #create" do
    before (:each) do
      controller.session[:user_id] = user.id
    end
    context "when valid params are passed" do
      it "responds with status code 302" do
        post :create, params: { article: { title: "Article", author_id: user.id, status: "unpublished" } }
        expect(response).to have_http_status 302
      end

      it "assigns a new article in the DB" do
        expect{post :create, params: { article: { title: "Article", author_id: user.id, status: "unpublished" } } }
        .to change(Article, :count).by(1)
      end

      it "assigns the newly created article as @article" do
        post :create, params: { article: { title: "Article", author_id: user.id, status: "unpublished" } }
        expect(assigns(:article)).to eq (Article.last)
      end

      it "redirects to the created game" do
        post :create, params: { article: { title: "Article", author_id: user.id, status: "unpublished" } }
        expect(response).to redirect_to (Article.last)
      end
    end

    context "when invalid params are passed" do
      it "responds with status code 200" do
        post :create, params: { article: { author_id: user.id, status: "unpublished" } }
        expect(response).to have_http_status 200
      end

      it "does not create a new article in the database" do
        expect{post :create, params: { article: { author_id: user.id, status: "unpublished" } } }
        .to change(Article, :count).by(0)
      end

      it "assigns the unsaved article as @article" do
        post :create, params: { article: { author_id: user.id, status: "unpublished" } }
        expect(assigns(:article)).not_to eq(Article.last)
      end

      it "renders the :new template" do
        post :create, params: { article: { author_id: user.id, status: "unpublished" } }
        expect(response).to render_template(:new)
      end
    end
    end

    describe "DELETE #destroy" do
    it "responds with status code 302" do
      delete :destroy, params: { id: article.id }
      expect(response).to have_http_status 302
    end

    # add validation test to check if user is admin

    it "destroys the requested article" do
      expect { delete(:destroy, params: { id: article.id }) }.to change(Article, :count).by(-1)
    end

    it "redirects to the articles list" do
      delete :destroy, params: { id: article.id }
      expect(response).to redirect_to articles_path
    end
  end
  end
end