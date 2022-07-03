require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar"  , password_confirmation: "foobar")
  end 

  test "名前とemailが正しいときに保存できることを確認するテスト" do
    assert @user.valid?
  end

  test "名前が空欄のときに保存でないことを確認するテスト" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "emailが空欄のときに保存でないことを確認するテスト" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "nameが50文字超えるときに失敗することを確認するテスト" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "emailが244文字超えるときに失敗することを確認するテスト" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "emailが正しいフォーマットのときに成功することを確認するテスト" do
    valid_adresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_adresses.each do |valid_adress|
      @user.email = valid_adress
      assert @user.valid?, "#{valid_adress.inspect} このメールアドレスは正しい形式です。"
    end
  end

  test "emailが正しくないフォーマットのときに失敗することを確認するテスト" do
    invalid_adresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_adresses.each do |invalid_adress|
      @user.email = invalid_adress
      assert_not @user.valid?, "#{invalid_adress.inspect} このメールアドレスは正しい形式ではありません。"
    end
  end

  test "emailがユニークで有ることを確認するテスト" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emailが小文字に変換されて保存されることを確認するテスト" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "passwordを空白で保存したら失敗することを確認するテスト" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "passwordを5文字以下で保存したら失敗することを確認するテスト" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
