<template>
	<view>
		<canvas canvas-id="invitationCanvas" style="width: 90vw; height: 90vh; margin: 0 5vw;" />
		<!-- #ifndef APP-PLUS -->
		<tui-button shadow shape="circle" margin="10rpx 0" @click="savePoster">保存图片分享</tui-button>
		<!-- #endif -->
		<!-- #ifdef APP-PLUS -->
		<tui-button style="float: left;" shadow width="40%" margin="20rpx" shape="circle" @click="savePoster">保存图片分享</tui-button>
		<tui-button style="float: right;" shadow width="40%" margin="20rpx" shape="circle" type="green" @click="sendWeixin">分享微信好友</tui-button>
		<!-- #endif -->
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				userId: '',
				nickname: '',
				invitationCode: '',
				headImgUrl: '',
				qrCodeUrl: '',
				tempHeadImg: '',
				tempQrCode: '',
				imagePath: ''

			}
		},
		onShow: function() {
			this.getInvitationInfo();
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getInvitationInfo();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			// 获取订单列表
			getInvitationInfo: function() {
				let that = this;
				util.request('distributor/getInvitationInfo').then(function(res) {
					if (res.code === 0) {
						that.userId = res.data.userId
						that.nickname = res.data.nickname
						that.invitationCode = res.data.invitationCode
						that.headImgUrl = res.data.headImgUrl
						that.qrCodeUrl = res.data.qrCodeUrl
						uni.downloadFile({
							url: res.data.headImgUrl,
							success(res) {
								if (res.statusCode === 200) {
									that.tempHeadImg = res.tempFilePath
								}
								that.drawInvitation();
							}
						})
					}

				});
			},
			drawInvitation: function() {
				let that = this;
				uni.downloadFile({
					//url网络图片地址必须要在小程序中配备合法域名
					url: that.qrCodeUrl,
					success(res) {
						if (res.statusCode === 200) {
							that.tempQrCode = res.tempFilePath

							const context = uni.createCanvasContext('invitationCanvas')
							// 背景图
							let canvasWidth = uni.getSystemInfoSync().windowWidth * 0.9
							let canvasHeight = uni.getSystemInfoSync().windowHeight * 0.9
							context.drawImage('/static/images/mall/img_invitation_bg.jpg', 0, 0, canvasWidth, canvasHeight)

							// 邀请人信息：头像
							let headImgX = 50
							let headImgY = canvasHeight * 0.11
							let headImgWidth = canvasWidth * 0.12
							let headImgHeight = canvasWidth * 0.12
							context.save()
							context.beginPath()
							context.arc(headImgWidth / 2 + headImgX, headImgHeight / 2 + headImgY, headImgWidth / 2, 0, Math.PI * 2)
							context.clip()
							context.drawImage(that.tempHeadImg, headImgX, headImgY, headImgWidth, headImgHeight)
							context.restore()

							// 邀请人信息：描述
							let headImgYCenter = headImgHeight / 2 + headImgY
							let discWidth = headImgWidth + headImgX + 10
							context.save()
							context.setFontSize(15)
							context.fillText(that.nickname, discWidth, headImgYCenter)
							context.setFillStyle('#8B8D8B')
							context.setFontSize(14)
							context.fillText("邀您一起分享赚佣金", discWidth, headImgYCenter + 16)
							context.restore()

							// 小程序码
							let qrcodeWidth = canvasWidth * 0.25
							let qrcodeHeight = canvasWidth * 0.25
							context.drawImage(that.tempQrCode, 50, canvasHeight * 0.74, qrcodeWidth, qrcodeHeight)

							// 描述
							context.save()
							let contextWidth = qrcodeWidth + 70
							let contextCenterHeight = canvasHeight * 0.74 + qrcodeWidth / 2
							let contextLineHeight = 20
							context.setFillStyle('#8B8D8B')
							context.setFontSize(12)
							context.fillText(util.projectName, contextWidth, contextCenterHeight - contextLineHeight)
							context.fillText('长按识别小程序码，即刻体验', contextWidth, contextCenterHeight)
							context.fillText('邀请码：', contextWidth, contextCenterHeight + contextLineHeight)
							context.setFillStyle('#2CA244')
							context.fillText(that.invitationCode, contextWidth + 48, contextCenterHeight + contextLineHeight)
							context.restore()

							context.draw()

							//将生成好的图片保存到本地
							setTimeout(function() {
								uni.canvasToTempFilePath({
									canvasId: 'invitationCanvas',
									success: function(res) {
										that.imagePath = res.tempFilePath
										that.canvasHidden = true
									},
									fail: function(res) {
										console.log(res);
									}
								});
							}, 200);
						}
					}
				})
			},
			//点击保存到相册
			savePoster: function() {
				var that = this
				uni.saveImageToPhotosAlbum({
					filePath: that.imagePath,
					success(res) {
						uni.showModal({
							content: '已保存到相册',
							showCancel: false,
							confirmText: '确定',
              // #ifndef MP-ALIPAY
              // 支付宝小程序不支持
              confirmColor: '#2BF39D',
              // #endif
							success: function(res) {
								if (res.confirm) {
									/* 该隐藏的隐藏 */
									that.maskHidden = false
								}
							},
							fail: function(res) {}
						})
					}
				})
			},
			sendWeixin() {
				var that = this
				uni.share({
					provider: "weixin",
					scene: "WXSceneSession",
					type: 2,
          title: util.projectName,
          summary: `我正在使用${util.projectName}，赶紧跟我一起来体验！`,
					imageUrl: that.imagePath,
					success: function(res) {
						console.log("success:" + JSON.stringify(res));
					},
					fail: function(err) {
						console.log("fail:" + JSON.stringify(err));
					}
				});
			}
		}
	}
</script>

<style>
</style>
