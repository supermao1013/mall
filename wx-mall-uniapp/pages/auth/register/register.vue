<template>
	<view>
		<view class="userinfo">
			<image @click="chooseImg" class="userinfo-avatar" :src="headImgUrl" background-size="cover"></image>
			<text @click="chooseImg" class="userinfo-nickname">点击选取头像</text>
		</view>
		<view>
			<view>
				<view class="login">
					<tui-datetime :type="2" ref="dateTime" setDateTime="1990-01-01" radius @confirm="changeBirthday">
					</tui-datetime>
					<view class="sex_box" @tap="showDateTime">
						<input placeholder-class="phcolor" disabled class="tui-input" v-model="birthday"
							placeholder="请选择生日" />
					</view>
					<view class="sex_box">
						<tui-radio-group @change="changeGender">
							<label>
								<tui-radio color="#E41F19" value="1">
								</tui-radio>
								<text class="tui-text">男</text>
							</label>
							<label>
								<tui-radio color="#E41F19" value="2">
								</tui-radio>
								<text class="tui-text">女</text>
							</label>
							<label>
								<tui-radio color="#E41F19" checked value="0">
								</tui-radio>
								<text class="tui-text">未知</text>
							</label>
						</tui-radio-group>
					</view>
					<view class="first-line">
						<input placeholder-class="phcolor" class="tui-input" v-model="nickname" placeholder="请输入昵称" />
					</view>
					<view class="first-line">
						<input password placeholder-class="phcolor" class="tui-input" placeholder="请输入密码" maxlength="8"
							v-model="password" />
					</view>
					<view class="first-line">
						<input password placeholder-class="phcolor" class="tui-input" placeholder="请再次输入密码"
							maxlength="8" v-model="rePassword" />
					</view>
					<view class="first-line">
						<input :disabled="isSend" placeholder-class="phcolor" class="tui-input" placeholder="请输入手机号码"
							maxlength="11" v-model="mobile" type='number' auto-focus />
					</view>
					<view class="second-line">
						<input type="digit" v-model="code" placeholder="四位验证码" />
						<button @tap="countDownPassCode" :disabled="disableGetMobileCode">{{getCodeButtonText}}</button>
					</view>
				</view>
				<view class="third-line">
					<tui-button type="danger" shape="circle" @click="postRegister" :disabled="disableSubmitMobileCode">
						注册</tui-button>
				</view>
				<view class="login-title-btn" @click="toLogin">已有账号去登录
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	let app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				headImgUrl: '/static/images/mall/img_not_tuxedo.png',
				nickname: '',
				gender: 0,
				birthday: '',
				mobile: '',
				password: '',
				rePassword: '',
				code: '',
				title: '用户注册',
				isSend: false,
				disableGetMobileCode: false,
				disableSubmitMobileCode: true,
				getCodeButtonText: '获取验证码'
			}
		},
		methods: {
			changeBirthday(e) {
				this.birthday = e.result;
			},
			showDateTime() {
				this.$refs.dateTime.show();
			},
			changeGender(event) {
				this.gender = event.detail.value
			},
			toLogin() {
				uni.navigateTo({
					url: '/pages/auth/login/login'
				})
			},
			chooseImg() {
				let that = this;
				uni.chooseImage({
					count: 1, //默认9
					sizeType: ['original', 'compressed'],
					sourceType: ['album'],
					success: function(res) {
						let tempFilePaths = res.tempFilePaths[0]
						util.uploadFile('upload/upload', tempFilePaths).then(function(resp) {
							that.headImgUrl = resp.url;
						})
					}
				})
			},
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
							let i = 60;
							let intervalId = setInterval(function() {
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
			postRegister: function(e) {
				let headImgUrl = this.headImgUrl;
				let nickname = this.nickname;
				let mobile = this.mobile;
				let password = this.password;
				let rePassword = this.rePassword;
				let code = this.code;
				let gender = this.gender;
				let birthday = this.birthday;

				if (!nickname) {
					util.toast('请输入昵称');
					return
				}
				if (password.length < 4 || password.length > 8) {
					util.toast('请输入4-8位登录密码');
					return
				}
				if (rePassword.length < 4 || rePassword.length > 8) {
					util.toast('请输入4-8位登录密码');
					return
				}
				if (password != rePassword) {
					util.toast('两次密码不一致！');
					return
				}
				if (!util.isMobile(mobile)) {
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

				util.request('auth/register', {
					headImgUrl: headImgUrl,
					nickname: nickname,
					mobile: mobile,
					password: password,
					rePassword: rePassword,
					code: code,
					gender: gender,
					birthday: birthday
				}, 'POST').then(function(res) {
					uni.hideLoading();
					if (res.code == 0) {
						//存储用户信息
						uni.setStorageSync('userInfo', res.userInfo);
						uni.setStorageSync('token', res.token);
						uni.setStorageSync('userId', res.userInfo.id);

						uni.showModal({
							title: '提示',
							content: '注册成功，自动登录到个人中心？',
							success: function(res) {
								if (res.confirm) {
									uni.reLaunch({
										url: '/pages/ucenter/index/index'
									});
								} else {
									uni.reLaunch({
										url: '/pages/index/index'
									});
								}
							}
						})
					} else {
						util.toast(res.msg);
					}
				})
			}
		},
		onLoad: function(options) {}
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

	.sex_box {
		color: #808080;
		text-align: center;
		margin: 10rpx 0 20rpx 0;
	}

	.tui-text {
		font-size: 28rpx;
		margin: 0 20rpx 0 5rpx;
	}

	/* 绑定手机号的两个form */

	.login-title {
		margin: 20rpx 0 35rpx;
		text-align: center;
		font-size: 30rpx;
	}

	.login-title-btn {
		color: #018DDF;
		font-size: 22rpx;
		float: right;
		margin: 40rpx 80rpx 0 0;
	}

	.login {
		font-size: 30rpx;
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
