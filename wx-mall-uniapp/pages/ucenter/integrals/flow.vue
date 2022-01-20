<template>
	<view class="container">
		<tui-tab :tabs="tabs" isSticky :current="currentTab" selectedColor="#E41F19" sliderBgColor="#E41F19"
			@change="change"></tui-tab>
		<view class="tui-records__list">
			<view v-for="(item,index) in recordsList" :key="index" v-show="currentTab==index">
				<tui-list-cell :hover="false" v-for="(model,subIndex) in item.data" :key="subIndex">
					<view class="tui-records__item">
						<image class="tui-icon"
							:src="'/static/images/mall/'+(model.type==2?'icon_expend_3x.png':'icon_income_3x.png')">
						</image>
						<view>
							<view class="tui-title">{{getText(model.typeDetail)}}</view>
						</view>
						<view class="tui-right__box">
							<view class="tui-amount" :class="{'tui-expend':model.type==2}">
								{{model.type==2?'-':'+'}}{{model.number||''}}
							</view>
							<view class="tui-desc">{{model.addTime||''}}</view>
						</view>
					</view>
				</tui-list-cell>
				<!--加载loading-->
				<tui-loadmore v-if="recordsList[index].loading" :index="3" type="red"></tui-loadmore>
				<tui-nomore v-if="!recordsList[index].pullUpOn"></tui-nomore>
				<!--加载loading-->
			</view>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				tabs: ["全部", "收入", "支出"],
				currentTab: 0,
				recordsList: [{
					loading: false,
					pullUpOn: true,
					pageIndex: 1,
					noData: false,
					data: []
				}, {
					loading: false,
					pullUpOn: true,
					pageIndex: 1,
					noData: false,
					data: []
				}, {
					loading: false,
					pullUpOn: true,
					pageIndex: 1,
					noData: false,
					data: []
				}],
				//模拟请求返回数据
				requestData: []
			}
		},
		onLoad() {
			this.getMycount()
		},
		onPullDownRefresh: function() {
			// 显示顶部刷新图标
			uni.showNavigationBarLoading();
			var that = this;

			that.getMycount()
			// 隐藏导航栏加载框
			uni.hideNavigationBarLoading();
			// 停止下拉动作
			uni.stopPullDownRefresh();
		},
		methods: {
			getText(typeDetail) {
				if (typeDetail === 1) {
					return '签到奖励';
				} else if (typeDetail === 2) {
					return '购物奖励';
				} else if (typeDetail === 3) {
					return '抽奖奖励';
				} else if (typeDetail === 4) {
					return '系统发放';
				} else if (typeDetail === 5) {
					return '兑换支出';
				}
			},
			getMycount() {
				var that = this;
				util.request('user/integralLogList').then(function(res) {
					if (res.code === 0) {
						that.requestData = res.data
						that.getRecordsList(that.currentTab)
					}
				});
			},
			change(e) {
				this.currentTab = e.index
				if (this.recordsList[this.currentTab].pageIndex == 1) {
					this.getRecordsList(this.currentTab)
				}
			},
			getRecordsList(index) {
				let item = this.recordsList[index]
				setTimeout(() => {
					uni.stopPullDownRefresh();
					let recordsList = [...this.requestData];
					if (this.currentTab > 0) {
						recordsList = recordsList.filter(item => item.type === this.currentTab)
					}
					if (item.pageIndex == 1) {
						item.data = recordsList;
					} else {
						item.data = item.data.concat(recordsList);
					}
					if (item.pageIndex > 2 || recordsList.length < 10) {
						item.pullUpOn = false;
					}
					item.pageIndex++;
					item.loading = false;
				}, 0)
			}
		},
		onPullDownRefresh() {
			let index = this.currentTab
			let item = this.recordsList[index]
			item.pageIndex = 1;
			item.loading = false;
			item.pullUpOn = true;
			item.noData = false;
			this.getMycount()
		}
	}
</script>

<style>
	.container {
		padding-bottom: env(safe-area-inset-bottom);
	}

	.tui-records__list {
		margin-top: 20rpx;
	}

	.tui-records__item {
		width: 100%;
		display: flex;
		align-items: center;
	}

	.tui-icon {
		width: 72rpx;
		height: 72rpx;
		margin-right: 20rpx;
	}

	.tui-title {
		font-size: 30rpx;
		font-weight: 400;
		color: #333333;
	}

	.tui-desc {
		font-size: 24rpx;
		font-weight: 400;
		color: #888888;
		padding-top: 12rpx;
	}

	.tui-right__box {
		margin-left: auto;
		text-align: right;
	}

	.tui-amount {
		font-size: 30rpx;
		font-weight: 400;
		color: #EB0909;
	}

	.tui-expend {
		color: #19be6b !important;
	}
</style>
