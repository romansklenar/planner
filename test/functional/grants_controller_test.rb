require 'test_helper'

class GrantsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Grant.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Grant.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Grant.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to grant_url(assigns(:grant))
  end
  
  def test_edit
    get :edit, :id => Grant.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Grant.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Grant.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Grant.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Grant.first
    assert_redirected_to grant_url(assigns(:grant))
  end
  
  def test_destroy
    grant = Grant.first
    delete :destroy, :id => grant
    assert_redirected_to grants_url
    assert !Grant.exists?(grant.id)
  end
end
