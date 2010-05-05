require 'test_helper'

class WorktypesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Worktype.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Worktype.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Worktype.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to worktype_url(assigns(:worktype))
  end
  
  def test_edit
    get :edit, :id => Worktype.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Worktype.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Worktype.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Worktype.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Worktype.first
    assert_redirected_to worktype_url(assigns(:worktype))
  end
  
  def test_destroy
    worktype = Worktype.first
    delete :destroy, :id => worktype
    assert_redirected_to worktypes_url
    assert !Worktype.exists?(worktype.id)
  end
end
