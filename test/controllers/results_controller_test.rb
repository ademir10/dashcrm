require 'test_helper'

class ResultsControllerTest < ActionController::TestCase
  setup do
    @result = results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create result" do
    assert_difference('Result.count') do
      post :create, result: { a10: @result.a10, a11: @result.a11, a12: @result.a12, a13: @result.a13, a14: @result.a14, a15: @result.a15, a1: @result.a1, a2: @result.a2, a3: @result.a3, a4: @result.a4, a5: @result.a5, a6: @result.a6, a7: @result.a7, a8: @result.a8, a9: @result.a9, research_id: @result.research_id }
    end

    assert_redirected_to result_path(assigns(:result))
  end

  test "should show result" do
    get :show, id: @result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @result
    assert_response :success
  end

  test "should update result" do
    patch :update, id: @result, result: { a10: @result.a10, a11: @result.a11, a12: @result.a12, a13: @result.a13, a14: @result.a14, a15: @result.a15, a1: @result.a1, a2: @result.a2, a3: @result.a3, a4: @result.a4, a5: @result.a5, a6: @result.a6, a7: @result.a7, a8: @result.a8, a9: @result.a9, research_id: @result.research_id }
    assert_redirected_to result_path(assigns(:result))
  end

  test "should destroy result" do
    assert_difference('Result.count', -1) do
      delete :destroy, id: @result
    end

    assert_redirected_to results_path
  end
end
