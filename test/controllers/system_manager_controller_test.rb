require 'test_helper'

class SystemManagerControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get db_drop" do
    get :db_drop
    assert_response :success
  end

  test "should get db_create" do
    get :db_create
    assert_response :success
  end

  test "should get db_migrate" do
    get :db_migrate
    assert_response :success
  end

  test "should get db_seed" do
    get :db_seed
    assert_response :success
  end

  test "should get db_init" do
    get :db_init
    assert_response :success
  end

end
