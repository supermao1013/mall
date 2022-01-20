<template>
	<view>
		<view class="userinfo">
			<image class="userinfo-avatar" background-size="cover"></image>
			<text class="userinfo-nickname"></text>
		</view>

		<view>
			<view>
				<view class="login-title">登录</view>
				<view class="login">
					<view class="first-line">
						<input placeholder-class="phcolor" class="tui-input" placeholder="请输入手机号码" maxlength="11"
							v-model="mobile" type='number' />
					</view>
					<view class="first-line">
						<input placeholder-class="phcolor" password class="tui-input" placeholder="登录密码" maxlength="8"
							v-model="password" />
					</view>
				</view>
				<view class="third-line">
					<tui-button type="danger" shape="circle" @click="startLogin">登录</tui-button>
				</view>
				<view class="form-item-text">
					<navigator url="/pages/auth/mobile/mobile?type=2" class="reset">忘记密码</navigator>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				mobile: '',
				password: ''
			}
		},
		methods: {
			startLogin: function() {
				let that = this;
				if (!util.isMobile(that.mobile)) {
					return
				}

				if (that.password.length < 1) {
					util.toast('请输入密码');
					return false;
				}
				util.request('auth/loginByMobile', {
					mobile: that.mobile,
					password: that.password
				}, 'POST').then(function(res) {
					if (res.code === 0) {
						//存储用户信息
						uni.setStorageSync('userInfo', res.userInfo);
						uni.setStorageSync('token', res.token);
						uni.setStorageSync('userId', res.userInfo.id);
						uni.reLaunch({
							url: '/pages/ucenter/index/index'
						});
					} else {
						util.toast(res.msg);
					}
				});
			}
		}
	}
</script>

<style>
	.userinfo {
		display: flex;
		flex-direction: column;
		align-items: center;
		padding-bottom: 25rpx;
		background: linear-gradient(to bottom, #e41f19 0%, #fff 100%);
	}

	.userinfo-avatar {
		width: 100rpx;
		height: 100rpx;
		border-radius: 50%;
		margin-top: 20rpx;
		margin-bottom: 25rpx;
	}

	.userinfo-nickname {
		color: #272727;
		font-size: 28rpx;
		line-height: 40rpx;
	}

	/* 绑定手机号的两个form */

	.login-title {
		margin: 20rpx 0 35rpx;
		text-align: center;
		font-size: 30rpx;
	}

	.login {
		font-size: 32rpx;
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.login .first-line {
		height: 80rpx;
		border: 1rpx solid rgb(217, 217, 217);
		border-radius: 40rpx;
		width: 600rpx;
		margin-bottom: 40rpx;
	}

	.login .first-line input {
		padding-left: 20rpx;
		height: 80rpx;
		width: 100%;
	}

	.login .second-line {
		height: 80rpx;
		display: flex;
		width: 600rpx;
		margin-bottom: 50rpx;
	}

	.login .second-line input {
		height: 80rpx;
		width: 350rpx;
		margin-right: 20rpx;
		border: 1rpx solid rgb(217, 217, 217);
		padding-left: 20rpx;
		border-radius: 5px;
	}

	.login .second-line button {
		text-align: center;
		height: 84rpx;
		line-height: 84rpx;
		width: 250rpx;
		font-size: 30rpx;
		background-color: #e41f19;
		color: #fff;
	}

	.login .password-second-line {
		height: 80rpx;
		display: flex;
		width: 600rpx;
		margin-bottom: 50rpx;
	}

	.login .password-second-line input {
		height: 80rpx;
		width: 600rpx;
		border: 1rpx solid rgb(217, 217, 217);
		padding-left: 20rpx;
		border-radius: 5px;
	}

	.third-line {
		margin-left: auto;
		margin-right: auto;
		width: 600rpx;
	}

	.third-line button {
		height: 80rpx;
		font-size: 32rpx;
		background-color: #e41f19;
		color: #fff;
	}

	.form-item-text {
		float: right;
		margin: 40rpx 80rpx 0 0;
		color: #018DDF;
		font-size: 22rpx;
	}
</style>
