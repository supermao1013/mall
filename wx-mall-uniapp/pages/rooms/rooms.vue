<template>
	<view class="container">
		<!--header-->
		<view class="tui-header-box" :style="{ height: height + 'px', background: 'rgba(255,255,255,' + opcity + ')' }">
			<view class="tui-header" :style="{ paddingTop: top + 'px', opacity: opcity }">
				直播房间
			</view>
		</view>
		<!--header-->
		<tui-show-empty v-if="rooms.length == 0" text="暂无直播间~"></tui-show-empty>
		<view class="tui-container" v-else>
			<view class="tui-extend-box">
				<block v-for="(item, index) in rooms" :key="index">
					<view class="tui-extend-tp">
						<view class="tui-extend-item" @tap="livePlayer(item.roomid)" :style="'background-image:url('+item.coverImg+');'">
							<view class="tui-top">
								<view class="living"></view>
								<text v-if="item.liveStatus===101">直播中</text>
								<text @tap="livePlayer(item.roomid)" v-if="item.liveStatus===103||item.liveStatus===105">观看回放</text>
								<text v-if="item.liveStatus===107">已过期</text>
								<subscribe class="subscribe" v-if="item.liveStatus===102" :room-id="item.roomid"></subscribe>
								<text v-if="item.liveStatus===102">开播：{{item.startTime}}</text>
								<!-- 观看人数暂未提供接口 -->
								<!-- <text v-if="item.liveStatus===101">1001人观看</text> -->
								<view class="tui-btn-box">
									<button open-type="share" @click.stop.prevent="nothing" class="tui-btn" :data-index="index">
										<tui-icon name="share" color="#fff" :size="20" tui-icon-class="tui-r-icon"></tui-icon>
									</button>
								</view>
							</view>

							<view class="tui-title tui-light">
								{{item.name}}
							</view>
						</view>

						<view class="tui-extend-goods" v-if="item.allGoods.length>0">
							<view class="tui-goods-box" :data-url="item.allGoods[0].url" @tap="gotoGoodsDetail">
								<view class="tui-goods-item" :style="'background-image:url('+item.allGoods[0].coverImg+');'">
								</view>
								<view class="tui-goods-info">
									<!-- <view class="tui-goods-name line-one">{{item.allGoods[0].name}}人观看</view> -->
									<view class="tui-goods-name line-two">{{item.allGoods[0].name}}</view>
									<view class="tui-goods-price">
										<text style="font-size:24rpx;padding-top:4rpx">￥</text><text class="tui-price-now">{{item.allGoods[0].price/100}}</text>
										<view class="tui-price-org" v-if="item.allGoods[0].price2>0">￥{{item.allGoods[0].price2/100}}</view>
									</view>
								</view>
							</view>
							<view class="tui-goods-box" v-if="item.allGoods.length>1" style="margin-top:10rpx" :data-url="item.allGoods[1].url"
							 @tap="gotoGoodsDetail">
								<view class="tui-goods-item" :style="'background-image:url('+item.allGoods[1].coverImg+');'">
								</view>
								<view class="tui-goods-info">
									<!-- <view class="tui-goods-name line-one">{{item.allGoods[0].name}}人观看</view> -->
									<view class="tui-goods-name line-two">{{item.allGoods[1].name}}</view>
									<view class="tui-goods-price">
										<text style="font-size:24rpx;padding-top:4rpx">￥</text><text class="tui-price-now">{{item.allGoods[1].price/100}}</text>
										<view class="tui-price-org" v-if="item.allGoods[1].price2>0">￥{{item.allGoods[1].price2/100}}</view>
									</view>
								</view>
							</view>
						</view>
						<view class="tui-extend-no-goods" v-else>
							<view class="tui-goods-box">
								<view class="tui-goods-item-no" :style="'background-image:url(../../static/images/mall/my_course_empty.png);'">
									<view class="tui-goods-name-no">暂未添加商品</view>
								</view>
							</view>
						</view>
					</view>
				</block>
			</view>
		</view>
	</view>
</template>

<script>
	const app = getApp()
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				height: 64, //header高度
				top: 0, //标题图标距离顶部距离
				scrollH: 0, //滚动总高度
				opcity: 0,
				iconOpcity: 0.5,
				rooms: [],
				sweixin: null
			}
		},
		onLoad(options) {
			// 页面初始化 options为页面跳转所带来的参数
			this.getRooms();
			this.width = app.globalData.customBar.width
			this.height = app.globalData.customBar.height
			this.top = app.globalData.customBar.top
			this.scrollH = app.globalData.customBar.scrollH
			// #ifdef MP-WEIXIN
			// App跳转到小程序直播
			if (options.roomId) {
				uni.navigateTo({
					url: 'plugin-private://wx2b03c6e691cd7370/pages/live-player-plugin?room_id=' + options.roomId,
				})
			}
			// #endif

			let that = this;
			// #ifdef APP-PLUS
			plus.share.getServices(function(s) {
				var shares = {};
				for (var i = 0; i < s.length; i++) {
					var t = s[i];
					shares[t.id] = t;
				}

				that.sweixin = shares['weixin']
			}, function(e) {
				console.log("获取分享服务列表失败：" + e.message);
			});
			//#endif
		},
		methods: {
			nothing() {
				//阻止事件冒泡
			},
			gotoGoodsDetail: function(e) {
				var url = e.currentTarget.dataset.url;
				url = url.replace(".html?", "?");
				wx.navigateTo({
					url: "/" + url
				})
			},
			getRooms: function() {
				let that = this;
				that.rooms = []

				util.request('live/roomList').then(res => {
					if (res.code === 0) {
						let roomList = res.data.records;
						roomList.forEach(function(item) {
							item.endTime = util.transDate(item.endTime, 'yyyy-MM-dd hh:mm:ss')
							item.startTime = util.transDate(item.startTime, 'yyyy-MM-dd hh:mm:ss')
						})

						that.rooms = roomList
					}
				});
			},
			livePlayer: function(id) {
				let that = this;
				// #ifdef MP-WEIXIN
				uni.navigateTo({
					url: 'plugin-private://wx2b03c6e691cd7370/pages/live-player-plugin?room_id=' + id,
				})
				// #endif

				//#ifdef APP-PLUS
				that.sweixin ? that.sweixin.launchMiniProgram({
					id: util.maAppId,
					path: 'pages/rooms/rooms?roomId=' + id,
					type: 0
				}) : plus.nativeUI.alert("当前环境不支持打开小程序!");
				//#endif

			}
		},
		onPageScroll(e) {
			let scroll = e.scrollTop <= 0 ? 0 : e.scrollTop;
			let opcity = scroll / this.scrollH;
			if (this.opcity >= 1 && opcity >= 1) {
				return;
			}
			this.opcity = opcity,
				this.iconOpcity = 0.5 * (1 - opcity < 0 ? 0 : 1 - opcity)
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			this.getRooms();
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onShareAppMessage: function(e) {
			let index = e.target.dataset.index;
			let title = this.rooms[index].name;
			let roomid = this.rooms[index].roomid;
			let coverImg = this.rooms[index].coverImg;
			return {
				title: title,
				imageUrl: coverImg,
				path: 'plugin-private://wx2b03c6e691cd7370/pages/live-player-plugin?room_id=' + roomid
			}
		}
	}
</script>

<style>
	page {
		-webkit-font-smoothing: antialiased;
	}

	.tui-header {
		width: 100%;
		font-size: 18px;
		line-height: 18px;
		font-weight: 500;
		height: 32px;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.tui-header-box {
		width: 100%;
		position: fixed;
		left: 0;
		top: 0;
		z-index: 9998;
	}

	.subscribe {
		padding-top: 100rpx;
		position: absolute;
		margin: 0 30rpx;
	}

	.tui-container {
		width: 100%;
		min-height: 1500rpx;
		padding: 100rpx 30rpx 0 30rpx;
		box-sizing: border-box;
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
		justify-content: space-between;
		background-color: #F2F2F2;
	}

	.tui-extend-box {
		flex: 1;
		height: 350rpx;
		margin-right: 10rpx;
	}

	.tui-extend-tp {
		display: flex;
		/* margin-right: 10rpx; */
	}

	.tui-extend-goods {
		flex: 1;
		height: 160rpx;
		/* margin-right: 10rpx; */
		flex-direction: column;
		background: #FFFFFF;
		border-radius: 10rpx;
	}

	.tui-extend-no-goods {
		flex: 1;
		height: 325rpx;
		flex-direction: column;
		background: #FFFFFF;
		border-radius: 10rpx;
	}

	.tui-goods-box {
		flex: 1;
		height: 160rpx;
		display: flex;
		flex-direction: row;
		margin-left: 10rpx;
		background-color: white;
	}

	.tui-goods-info {
		flex: 1;
		/* display: flex; */
		/* flex-direction: column; */
		padding-top: 10rpx;
		margin-left: 10rpx;
		/* justify-content: flex-start; */
		/* align-items: flex-start; */
	}

	.tui-goods-name {
		width: 174rpx;
		height: 50rpx;
		font-size: 20rpx;
		font-family: PingFang SC;
		font-weight: bold;
		color: #333333;
		opacity: 1;
	}

	.tui-goods-price {
		margin-top: 20rpx;
		flex-direction: row;
		font-size: 28rpx;
		display: flex;
		color: red;
	}

	.tui-price-now {
		font-weight: bold;
	}

	.tui-price-org {
		color: #A0A0A0;
		text-decoration: line-through;
		margin-left: 10rpx;
	}

	.tui-goods-item-no {
		flex: 1;
		height: 330rpx;
		border-radius: 10rpx;
		box-shadow: 0px 6rpx 12rpx rgba(0, 0, 0, 0.16);
		background-size: cover;
	}

	.tui-goods-name-no {
		width: 174rpx;
		height: 50rpx;
		padding: 220rpx 0 0 120rpx;
		font-size: 20rpx;
		font-family: PingFang SC;
		font-weight: bold;
		color: #333333;
		opacity: 1;
	}

	.tui-goods-item {
		width: 160rpx;
		height: 160rpx;
		border-radius: 10rpx;
		/* background: #DD2F28; */
		/* border: 1px solid #707070; */
		box-shadow: 0px 6rpx 12rpx rgba(0, 0, 0, 0.16);
		/* opacity: 0.39; */
		background-size: cover;
	}

	.tui-extend-box:last-child {
		margin-right: 0;
	}

	.tui-extend-item {
		flex: 0 0 340rpx;
		margin-bottom: 20rpx;
		color: #fff;
		background-color: #fff;
		font-family: "Microsoft YaHei";
		text-align: justify;
		word-break: break-all;
		word-wrap: break-word;
		position: relative;
		width: 340rpx;
		height: 330rpx;
		background-repeat: no-repeat;
		background-size: 100% 100%;
		border-radius: 20rpx 0 0 20rpx;
		box-shadow: 4rpx 4rpx 2rpx rgba(0, 0, 0, 0.2);
	}

	/* .tui-extend-item::before {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  background: rgba(0, 0, 0, 0.2);

} */

	.tui-title {
		font-size: 24rpx;
		text-align: left;
		margin-left: 20rpx;
		margin-top: 200rpx;
		line-height: 40rpx;
		font-weight: bold;
		position: relative;
	}

	.tui-sub-title {
		font-size: 32rpx;
		padding-top: 30rpx;
		color: #4183C4;
		position: relative;
		z-index: 10;
	}

	.tui-time {
		font-size: 22rpx;
		color: red;
	}

	.tui-top {
		display: inline-block;
		width: 100%;
		vertical-align: middle;
		/* align-items: center;
  justify-content: space-between; */
		/* position: relative; */
		z-index: 10;
		height: 68rpx;
		background: linear-gradient(180deg, rgba(0, 0, 0, 0.2) 0%, rgba(0, 0, 0, 0.1) 100%);
		opacity: 1;
		border-radius: 10px 0px 0px 0px;
	}

	.tui-top text {
		margin-left: 10rpx;
		margin-top: 24rpx;
		font-size: 20rpx;
		font-weight: 400;
	}

	.living {
		margin-top: 24rpx;
		display: inline-block;
		border-radius: 50%;
		width: 16rpx;
		height: 16rpx;
		margin-left: 20rpx;
		background-color: red;
	}

	.tui-r-icon {
		padding-left: 16rpx;
		padding-bottom: 5rpx;
	}

	.tui-l-icon {
		padding: 0 10rpx 5rpx 8rpx;
	}

	button::after {
		border: none;
	}

	.tui-btn-box {
		float: right;
		height: 58rpx;
		margin-right: 10rpx;
	}

	.tui-btn {
		/* margin-right: 20rpx; */
		margin-top: -10rpx;
		background: none;
		padding: 0;
		height: 68rpx;
	}

	.tui-bg-1 {
		background: #282537;
		background-image: -webkit-radial-gradient(top, circle cover, #3c3b52 0%, #252233 80%);
		background-image: radial-gradient(top, circle cover, #3c3b52 0%, #252233 80%);
	}

	.tui-bg-2 {
		background: #092756;
		background: -webkit-radial-gradient(0% 100%, ellipse cover, rgba(104, 128, 138, 0.4) 10%, rgba(138, 114, 76, 0) 40%),
			-webkit-linear-gradient(top, rgba(57, 173, 219, 0.25) 0%, rgba(42, 60, 87, 0.4) 100%),
			-webkit-linear-gradient(-45deg, #670d10 0%, #092756 100%);
		background: -webkit-radial-gradient(0% 100%, ellipse cover, rgba(104, 128, 138, 0.4) 10%, rgba(138, 114, 76, 0) 40%),
			linear-gradient(to bottom, rgba(57, 173, 219, 0.25) 0%, rgba(42, 60, 87, 0.4) 100%),
			linear-gradient(135deg, #670d10 0%, #092756 100%);
	}

	.tui-bg-3 {
		background-image: linear-gradient(#8b9da9, #fff6e4);
		box-shadow: inset 0 0 100px hsla(0, 0%, 0%, 0.3);
	}

	.tui-bg-4 {
		background: rgb(105, 155, 200);
		background: -webkit-gradient(radial, top left, 0px, top left, 100%, color-stop(0%, rgba(105, 155, 200, 1)), color-stop(57%, rgba(181, 197, 216, 1)));
		background: -webkit-radial-gradient(top left, ellipse cover, rgba(105, 155, 200, 1) 0%, rgba(181, 197, 216, 1) 57%);
	}

	.tui-bg-5 {
		background-image: linear-gradient(45deg, rgba(194, 233, 221, 0.5) 1%, rgba(104, 119, 132, 0.5) 100%),
			linear-gradient(-45deg, #494d71 0%, rgba(217, 230, 185, 0.5) 80%);
	}

	.tui-bg-6 {
		background: rgb(244, 226, 156);
		background: -webkit-linear-gradient(-45deg, rgba(244, 226, 156, 0) 0%, rgba(59, 41, 58, 1) 100%),
			-webkit-linear-gradient(left, rgba(244, 226, 156, 1) 0%, rgba(130, 96, 87, 1) 100%);
		background: linear-gradient(135deg, rgba(244, 226, 156, 0) 0%, rgba(59, 41, 58, 1) 100%),
			linear-gradient(to right, rgba(244, 226, 156, 1) 0%, rgba(130, 96, 87, 1) 100%);
	}

	.tui-light {
		color: #fff;
		text-shadow: 0 0 0.1em rgba(0, 0, 0, 0.3), 0 0 0.2em rgba(0, 0, 0, 0.3);
	}
</style>
