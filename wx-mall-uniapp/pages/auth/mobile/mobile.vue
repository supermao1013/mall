<template>
	<view>
		<view class="userinfo">
			<image class="userinfo-avatar" :src="userInfo.headImgUrl" background-size="cover"></image>
			<text class="userinfo-nickname">{{userInfo.nickname}}</text>
		</view>

		<view>
			<view>
				<view class="login-title">{{title}}</view>
				<view class="login">
					<view class="first-line">
						<input :disabled="isSend" placeholder-class="phcolor" class="tui-input" placeholder="请输入手机号码"
							maxlength="11" v-model="mobile" type='number' auto-focus />
					</view>
					<view class="first-line">
						<input placeholder-class="phcolor" class="tui-input" placeholder="重置密码" maxlength="8"
							v-model="password" />
					</view>
					<view class="second-line">
						<input type="digit" v-model="code" placeholder="四位验证码" />
						<button @tap="countDownPassCode" :disabled="disableGetMobileCode">{{getCodeButtonText}}</button>
					</view>
				</view>
				<view class="third-line">
					<tui-button type="danger" shape="circle" @click="bindLoginMobilecode"
						:disabled="disableSubmitMobileCode">
						提交</tui-button>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	var app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				title: '绑定手机',
				mobile: '',
				password: '',
				code: '',
				userInfo: {
					headImgUrl: '',
					nickname: ''
				},
				type: 0,
				isSend: false,
				disableGetMobileCode: false,
				disableSubmitMobileCode: true,
				getCodeButtonText: '获取验证码'
			}
		},
		methods: {
			countDownPassCode: function() {
				let that = this;
				if (!util.isMobile(that.mobile)) {
					return
				}
				uni.showLoading({
					title: '发送中...'
				})
				util.request('index/smsCode', {
						phone: that.mobile
					}, 'POST', 'application/json')
					.then(function(res) {
						if (res.code == 0) {
							that.isSend = true
							util.toast(res.msg)
							var i = 60;
							var intervalId = setInterval(function() {
								i--
								if (i <= 0) {
									that.disableGetMobileCode = false
									that.disableSubmitMobileCode = false
									that.getCodeButtonText = '获取验证码'
									clearInterval(intervalId)
								} else {
									that.getCodeButtonText = i
									that.disableGetMobileCode = true
									that.disableSubmitMobileCode = false
								}
							}, 1000);
						} else {
							util.toast('发送失败');
						}
					});
			},
			bindLoginMobilecode: function(e) {
				var mobile = this.mobile;
				var password = this.password;
				var code = this.code;
				var that = this;

				if (!util.isMobile(mobile)) {
					return
				}
				if (password.length < 4 || password.length > 8) {
					util.toast('请输入4-8位登录密码');
					return
				}
				if (!code) {
					util.toast('请输入验证码');
					return
				}
				if (code.length != 4) {
					util.toast('请输入4位验证码');
					return
				}
				uni.showLoading({
					title: '提交中...'
				})
				var url = that.type == 2 ? 'index/modifyPw' : 'index/bindMobile';

				util.request(url, {
					mobileCode: code,
					mobile: mobile,
					password: password
				}, 'POST').then(function(res) {
					uni.hideLoading();
					if (res.code == 0) {
						uni.showModal({
							title: '提示',
							content: res.msg,
							showCancel: false,
							success: function(res) {
								if (res.confirm) {
									if (that.type == 1) {
										uni.reLaunch({
											url: '/pages/auth/login/login'
										});
									} else {
										uni.reLaunch({
											url: '/pages/ucenter/index/index'
										});
									}
								}
							}
						})
					} else {
						util.toast(res.msg);
					}
				})
			}
		},

		onLoad: function(options) {
			let that = this
			let type = Number(options.type)
			this.type = type
			if (type === 1) {
				util.request('user/userInfo').then(function(res) {
					if (res.code === 0) {
						that.userInfo = res.data
						if (res.data.mobile) {
							that.mobile = res.data.mobile
							that.isSend = true
							that.title = '修改密码'
						}
					}
				});
				if (!app.globalData.token) {
					let token = uni.getStorageSync('userToken')
					if (token) {
						app.globalData.token = token
					}
				}
			} else if (type === 2) {
				that.title = '重置密码'
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
		margin-bottom: 20rpx;
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
		border-radius: 40rpx;
	}

	.login .second-line button {
		text-align: center;
		height: 84rpx;
		line-height: 84rpx;
		width: 250rpx;
		font-size: 30rpx;
		background-color: #e41f19;
		color: #fff;
		border-radius: 40rpx;
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
</style>
