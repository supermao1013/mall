<template>
	<view class="container">
		<view class="tui-flex">
			<view class="tui-cube-box">
				<view class="tui-cube tui-cube-1">Vue</view>
				<view class="tui-cube tui-cube-2">SpringBoot</view>
				<view class="tui-cube tui-cube-3">MyBatisPlus</view>
				<view class="tui-cube tui-cube-4">MySQL</view>
				<view class="tui-cube tui-cube-5">elementUI</view>
				<view class="tui-cube tui-cube-6">uniapp</view>
			</view>

		</view>
		<view class="tui-content-box">
			<view class="tui-content">尊敬的用户您好，欢迎使用微同商城！</view>
			<view class="tui-content">微同商城旗舰版是微同科技为企业用户定制的微信小程序商城项目，管理系统前端使
				用Vue+elementUI，小程序前端使用uniapp和原生开发(两套代码可以按照自己的技术栈选择)，后台基于SpringBoot 2 开发，微信相关开发使用WxJava，
				数据库操作使用Mybatis升级版MyBatisPlus，实现前后端分离。能够有效降低企业开发成本，提升开发效率。
				后台体验地址（admin/admin）
				<text class="tui-content-email" @tap="copy" data-text="http://fly2you.cn/admin">http://fly2you.cn/admin</text>。</view>
			<view class="tui-content">H5商城：
				<text class="tui-content-email" @tap="copy" data-text="https://fly2you.cn/adminH5">https://fly2you.cn/adminH5</text>
			</view>
			<view class="tui-content">项目可能还存在缺陷或者bug，如果您在使用过程中发现问题或者有更好的建议，可反馈给我们。</view>
			<view class="tui-content">
				您可以通过反馈或者以下方式联系我！
			</view>
			<view class="tui-content tui-content-email" @tap="copy" data-text="939961241">939961241@qq.com</view>
			<view class="tui-content tui-content-email" @tap="copy" data-text="151602347">QQ交流群：151602347</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		onShareAppMessage: function() {
			return {
				title: '安徽微同科技有限公司',
				desc: '关于我们',
				path: 'pages/ucenter/about/about'
			}
		},
		onShareTimeline: function() {
			return {
				title: '安徽微同科技有限公司-关于我们',
				path: 'pages/ucenter/about/about'
			}
		},
		onLoad: function() {
			// #ifdef MP-WEIXIN
			uni.showShareMenu({
				withShareTicket: true,
				menus: ['shareAppMessage', 'shareTimeline']
			})
			// #endif
		},
		methods: {
			copy: function(e) {
				let text = e.currentTarget.dataset.text;
				// #ifndef H5
				uni.setClipboardData({
					data: text,
					success(res) {
						uni.getClipboardData()
					}
				})
				// #endif
				// #ifdef H5
				if (text.indexOf('fly2you.cn') > 0) {
					window.open(text)
				}
				if (text.indexOf('151602347') >= 0) {
					window.open('https://qm.qq.com/cgi-bin/qm/qr?k=hQLMx7vYLfP_C-d2-yP_udx1yciJXfHC&jump_from=webapi')
				}
				if (text.indexOf('939961241') >= 0) {
					window.open('tencent://message/?Site=baidu.com&uin=939961241&Menu=yes')
				}
				// #endif
			}
		}
	}
</script>

<style>
	.container {
		background-color: #fff;
		padding: 0 50rpx 40rpx 50rpx;
		box-sizing: border-box;
		overflow: hidden;
	}

	.tui-flex {
		display: flex;
		align-items: center;
		justify-content: center;
		padding-top: 40px;
	}

	.tui-cube-box {
		width: 60px;
		height: 60px;
		position: relative;
		-webkit-transform-style: preserve-3d;
		transform-style: preserve-3d;
		animation: tui-go 4s linear infinite;
	}

	@keyframes tui-go {
		0% {
			-webkit-transform: rotateX(0) rotateY(0);
			transform: rotateX(0) rotateY(0);
		}

		100% {
			-webkit-transform: rotateX(360deg) rotateY(360deg);
			transform: rotateX(360deg) rotateY(360deg);
		}
	}

	.tui-cube {
		width: 60px;
		height: 60px;
		position: absolute;
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 5px;
		box-sizing: border-box;
		font-size: 24rpx;
		color: #fff;
		text-align: center;
		word-break: break-all;
		word-wrap: break-word;
	}

	.tui-cube-1 {
		background: #fff;
		-webkit-transform: rotateY(90deg) translateZ(-30px);
		transform: rotateY(90deg) translateZ(-30px);
		color: #333 !important;
	}

	.tui-cube-2 {
		background: #8a5966;
		-webkit-transform: rotateY(90deg) translateZ(30px);
		transform: rotateY(90deg) translateZ(30px);
	}

	.tui-cube-3 {
		background: linear-gradient(-90deg, #5677fc, #5c8dff);
		-webkit-transform: rotateX(90deg) translateZ(30px);
		transform: rotateX(90deg) translateZ(30px);
	}

	.tui-cube-4 {
		background: #ed3f14;
		-webkit-transform: rotateX(90deg) translateZ(-30px);
		transform: rotateX(90deg) translateZ(-30px);
	}

	.tui-cube-5 {
		background: #ff7900;
		-webkit-transform: translateZ(30px);
		transform: translateZ(30px);
	}

	.tui-cube-6 {
		background: #19be6b;
		-webkit-transform: translateZ(-30px);
		transform: translateZ(-30px);
	}

	.tui-content-box {
		width: 100%;
		margin-top: 50px;
		padding: 30rpx;
		box-sizing: border-box;
		background: #fff;
		border-radius: 10rpx;
		box-shadow: 0 0 10rpx #eee;
	}

	.tui-content {
		color: #333;
		font-size: 30rpx;
		line-height: 44rpx;
		padding: 10rpx 0;
		text-align: justify;
	}

	.tui-content-email {
		color: #5677fc !important;
	}

	.tui-footer {
		display: flex;
		align-items: center;
		padding-top: 30rpx;
	}

	.tui-applets {
		width: 80px;
		height: 80px;
		display: block;
	}

	.tui-footer-text {
		font-size: 24rpx;
		color: #999;
		padding-left: 20rpx;
		width: 300rpx;
	}
</style>
