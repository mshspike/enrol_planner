require 'test_helper'

class StreamUnitsControllerTest < ActionController::TestCase
  setup do
    @stream_unit = stream_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stream_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stream_unit" do
    assert_difference('StreamUnit.count') do
      post :create, stream_unit: { stream_id: @stream_unit.stream_id, unit_id: @stream_unit.unit_id }
    end

    assert_redirected_to stream_unit_path(assigns(:stream_unit))
  end

  test "should show stream_unit" do
    get :show, id: @stream_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stream_unit
    assert_response :success
  end

  test "should update stream_unit" do
    patch :update, id: @stream_unit, stream_unit: { stream_id: @stream_unit.stream_id, unit_id: @stream_unit.unit_id }
    assert_redirected_to stream_unit_path(assigns(:stream_unit))
  end

  test "should destroy stream_unit" do
    assert_difference('StreamUnit.count', -1) do
      delete :destroy, id: @stream_unit
    end

    assert_redirected_to stream_units_path
  end
end
