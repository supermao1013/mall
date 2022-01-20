<template>
	<view class="dcenter-apply">
		<view class="block-container">
			<text class="subtitle">分销商特权</text>
			<view class="flex-container align-end">
				<image class="pig" src="/static/images/mall/saving_pot.png"></image>
				<view class="text-container">
					<text class="text1">销售赚佣金</text>
					<text class="text2">分享该小程序或商品给好友，成功下单后即可获得佣金</text>
					<navigator class="learn-more" url="">了解更多详情></navigator>
				</view>
			</view>
		</view>
		<form v-if="!user">
			<view class="block-container">
				<text class="subtitle">申请人信息</text>
				<view class="form-container required">
					<text class="form-label">姓名</text>
					<input placeholder="请输入真实姓名" maxlength="14" v-model="form.name" confirm-type="next" />
				</view>
				<view class="form-container required">
					<text class="form-label">手机号</text>
					<input placeholder="请输入手机号码" maxlength="11" v-model="form.mobile" type='number' />
				</view>
				<view class="form-container required">
					<text class="form-label">验证码</text>
					<input placeholder="请输入验证码" maxlength="6" v-model="form.mobileCode" type='number' />
					<button class="captcha-button" :disabled="!!captcha.cooldown" @tap="sendSms">
						{{ !!captcha.cooldown ? captcha.cooldown+'秒后重新获取' : '获取验证码' }}
					</button>
				</view>
				<view class="form-container">
					<text class="form-label">邀请码</text>
					<input placeholder="请输入邀请码" @input="bindCodeInput" maxlength="11" v-model="form.code" type='number' :disabled="codeDisabled" />
				</view>
				<view class="form-container">
					<text class="form-label">邀请人</text>
					<input disabled="true" :value="inviter" />
				</view>
			</view>
			<view class="block-container">
				<tui-button type="primary" shape="circle" @click="submitApply">申请成为分销商</tui-button>
			</view>
		</form>
    <view class="block-container" v-else>
      <text class="subtitle">您已申请等待审核</text>
      <view class="form-container">
        <text class="form-label">姓名</text>
        <input placeholder="姓名" v-model="form.name" confirm-type="next" disabled />
      </view>
      <view class="form-container">
        <text class="form-label">邀请码</text>
        <input placeholder="邀请码" v-model="form.code" type='number' disabled/>
      </view>
      <view class="form-container">
        <text class="form-label">邀请人</text>
        <input disabled :value="inviter"/>
      </view>
    </view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				form: {
					name: '',
					mobile: null,
					mobileCode: null,
					code: null
				},
				inviter: null,
        user: null,
				isShare: false,
				codeDisabled: false,
				timeoutId: null,
				captcha: {
					cooldown: 0,
					intervalId: null
				}
			}
		},
		// 扫小程序码接收参数
		onLoad(options) {
			this.form.code = options.scene
			this.isShare = true
			uni.setStorageSync('navUrl', '/pages/dcenter/apply/apply?scene=' + options.scene);
			this.getInviter()
		},
		methods: {
			bindCodeInput(event) {
				this.form.code = event.detail.value
				this.inviter = null

				this.getInviter()
			},
			getInviter() {
				const form = this.form

				clearTimeout(this.timeoutId)
				this.timeoutId = setTimeout(() => {
					util.request('distributor/getInviter', {
						code: form.code,
						isShare: this.isShare,
					}).then((res) => {
            let data = res.data
						this.codeDisabled = data.disabled
						this.inviter = data.inviter

						if (this.codeDisabled) {
							this.form.code = data.code
						}

            if (data.user) {
              this.user = data.user
              // 审核通过自动跳转到分销商页面
              if (this.user.isAudit) {
                uni.redirectTo({
                  url: '/pages/dcenter/index/index'
                });
              }
              this.form.name = data.user.name
            }
					})
				}, 1200)
			},
			sendSms() {
				let that = this;
				if (!util.isMobile(that.form.mobile)) {
					return
				}
				util.request('index/smsCode', {
						phone: this.form.mobile
					}, 'POST')
					.then(() => {
						// 再次发送倒计时
						const intervalId = setInterval(() => {
							this.captcha.cooldown--
							if (this.captcha.cooldown <= 0) {
								clearInterval(this.captcha.intervalId)
								this.captcha = {
									cooldown: 0,
									intervalId: null
								}
							}
						}, 1000)

						this.captcha = {
							cooldown: 60,
							intervalId
						}
					})
			},
			submitApply() {
        var name = this.form.name;
        var mobile = this.form.mobile;
        var mobileCode = this.form.mobileCode;

        if (!name) {
          util.toast('请输入姓名');
          return
        }
        if (!mobile) {
          util.toast('请输入手机号');
          return
        }
        if (!mobileCode) {
          util.toast('请输入验证码');
          return
        }
				util.request('distributor/apply', this.form, 'POST').then(() => {
					uni.redirectTo({
						url: '/pages/dcenter/index/index'
					})
				})
			}
		}
	}
</script>

<style>
	.dcenter-apply {
		padding: 32rpx;
	}

	.block-container {
		margin-bottom: 42rpx;
	}

	.subtitle {
		padding-bottom: 16rpx;
		color: #333333;
		display: block;
		font-size: 42rpx;
		border-bottom: 2rpx solid #d7d7d7;
	}

	.flex-container {
		display: flex;
	}

	.align-end {
		align-items: flex-end;
	}

	.pig {
		width: 128rpx;
		height: 128rpx;
		flex-shrink: 0;
	}

	.text-container {
		margin-left: 8rpx;
	}

	.text1 {
		display: block;
		padding: 16rpx 0;
		font-weight: 300;
	}

	.text2 {
		color: #aaa;
		font-weight: 300;
	}

	.learn-more {
		color: #02a7f0;
		font-size: 24rpx;
		display: inline-block;
		margin-left: 16rpx;
	}

	.required {
		position: relative;
	}

	.required::before {
		content: "*";
		color: #d9001b;
		position: absolute;
		left: -8px;
		top: 24rpx;
		font-size: 42rpx;
	}

	.form-container {
		display: flex;
		border-bottom: 2rpx solid #d7d7d7;
		padding: 24rpx 24rpx 24rpx 0;
		margin-left: 24rpx;
		align-items: center;
	}

	.form-label {
		width: 192rpx;
		flex-shrink: 0;
	}

	.captcha-button {
		border: 0;
		font-size: 26rpx;
		padding: 0;
		background: none;
		color: #02a7f0;
		line-height: 1;
		width: 300rpx;
	}

	.captcha-button::after {
		border: 0;
	}
</style>
