<template>
	<view class="dcenter-order">
		<view v-if="teamListFL.length <= 0">
			<view class="no-team">
				<image src="/static/images/mall/my_course_empty.png" class="no-team-image"></image>
			</view>
			<view><text class="no-team-text">暂无团队成员</text></view>
		</view>
		<view v-else class="list">
			<view>
				<text class="title">一级团队（{{teamListFL.length}}人）</text>
			</view>
			<view v-for="(item, index) in teamListFL" :key="index" class="team-list" :data-id="item.id" :data-team-count="item.teamCount"
			 @tap="getSLTeam">
				<view class="team-content">
					<view>
						<image :src="item.headImgUrl" class="img"></image>
					</view>
					<view class="middle">
						<text class="name">{{item.nickname}}</text>
						<text class="join-time">{{item.joinTime}}</text>
					</view>
					<view class="right">
						<text>二级团队（{{item.teamCount}}人）</text>
					</view>
					<view v-if="item.teamCount > 0" class="icon">
						<image src="/static/images/mall/address_right.png" :class="'img ' + (activeId === item.id ? 'active-img' : '')"></image>
					</view>
				</view>
				<!-- 二级团队 -->
				<view v-if="activeId === item.id" class="team-content-sl">
					<view v-for="(item, index) in teamListSL" :key="index" class="team-list-sl">
						<view>
							<image src="/static/images/mall/mine_def_touxiang_3x.png" class="img-sl"></image>
						</view>
						<view class="middle-sl">
							<text class="name-sl">{{item.nickname}}</text>
							<text class="join-time-sl">{{item.joinTime}}</text>
						</view>
					</view>
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
				activeId: 0,
				teamListFL: [], //一级团队列表 
				teamListSL: [], //二级团队列表
				current: 1,
				limit: 100000,
				pages: 1
			}
		},
		// 下拉刷新
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();

			this.activeId = 0

			this.getTeamList("FL");
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		onShow: function() {
			this.initial();
		},
		methods: {
			initial: function() {
				this.getTeamList("FL");
			},
			// 获取团队列表
			getTeamList: function(type) {
				let that = this;
				util.request('distributor/myDistTeam', {
					type: type,
					id: that.activeId,
					current: 1,
					limit: that.limit * that.current,
				}).then(function(res) {
					if (res.code === 0) {
						if (type == 'FL') {
							that.teamListFL = res.data.records
						} else {
							that.teamListSL = res.data.records
						}
					}
				});
			},
			getSLTeam: function(event) {
				let that = this;
				let id = event.currentTarget.dataset.id
				let teamCount = event.currentTarget.dataset.teamCount
				if (teamCount == 0) return false
				if (id == that.activeId) {
					that.activeId = 0
					return false
				}
				that.activeId = id
				that.getTeamList("SL");
			}
		}
	}
</script>

<style>
	page {
		background: #f2f2f2;
	}

	.no-team {
		display: flex;
		justify-content: center;
	}

	.no-team-image {
		margin-top: 100px;
		width: 300rpx;
		height: 300rpx;
	}

	.no-team-text {
		display: flex;
		justify-content: center;
		font-size: 48rpx;
		color: #BCBCBC;
	}

	.list {
		width: 100%;
	}

	.list .title {
		background-color: #fff;
		display: flex;
		justify-content: center;
		padding: 20rpx 0;
		font-size: 40rpx;
		font-weight: 400;
		color: #FB5D5D;
		border-bottom: 3rpx solid #FB5D5D;
		margin-bottom: 20rpx;
	}

	.team-list {
		width: 100%;
		box-sizing: border-box;
		position: relative;
		padding: 10rpx 15rpx;
	}

	.team-content {
		width: 100%;
		background: #fff;
		box-shadow: 0 3rpx 20rpx rgba(183, 183, 183, 0.1);
		border-radius: 10rpx;
		-webkit-border-radius: 10rpx;
		overflow: hidden;
	}

	.team-content .img {
		margin: 20rpx;
		float: left;
		width: 100rpx;
		height: 100rpx;
		border-radius: 50%;
		-webkit-border-radius: 50%;
		overflow: hidden;
	}

	.team-content .middle {
		float: left;
		margin: 20rpx 0;
	}

	.team-content .middle .name {
		font-size: 35rpx;
		font-weight: 400;
		margin-top: 20rpx;
		color: #5E5E5E;
	}

	.team-content .middle .join-time {
		margin-top: 10rpx;
		font-size: 25rpx;
		color: #BCBCBC;
		display: block;
	}

	.team-content .right {
		float: left;
		margin: 0 20rpx 0 0;
	}

	.team-content .right text {
		height: 140rpx;
		width: 235rpx;
		text-align: right;
		display: table-cell;
		vertical-align: middle;
		font-size: 25rpx;
		font-weight: 400;
		color: #FB5D5D;
	}

	.team-content .icon {
		float: right;
	}

	.team-content .icon .img {
		margin: 50rpx 30rpx 50rpx 0;
		width: 40rpx;
		height: 40rpx;
		display: table-cell;
		vertical-align: middle;
	}

	.team-content .icon .active-img {
		transform: rotate(90deg);
		-ms-transform: rotate(90deg);
		/* IE 9 */
		-moz-transform: rotate(90deg);
		/* Firefox */
		-webkit-transform: rotate(90deg);
		/* Safari 和 Chrome */
		-o-transform: rotate(90deg);
		/* Opera */
	}

	/* 二级团队样式 */
	.team-content-sl {
		width: 100%;
		background: #fff;
		box-sizing: border-box;
		position: relative;
		margin-top: -10rpx;
		border-radius: 10rpx;
		-webkit-border-radius: 10rpx;
	}

	.team-content-sl .team-list-sl {
		background: #fff;
		overflow: hidden;
		margin-left: 130rpx;
	}

	.team-content-sl .team-list-sl .img-sl {
		margin: 10rpx 10rpx 10rpx 0;
		float: left;
		width: 80rpx;
		height: 80rpx;
		border-radius: 50%;
		-webkit-border-radius: 50%;
		/* overflow: hidden; */
	}

	.team-content-sl .team-list-sl .middle-sl {
		float: left;
		margin: 25rpx 15rpx 10rpx 0;
	}

	.team-content-sl .team-list-sl .middle-sl .name-sl {
		font-size: 25rpx;
		font-weight: 400;
		margin-top: 10rpx;
		color: #5E5E5E;
	}

	.team-content-sl .team-list-sl .middle-sl .join-time-sl {
		font-size: 25rpx;
		margin-top: 5rpx;
		display: block;
		color: #BCBCBC;
	}
</style>
