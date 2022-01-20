<template>
	<view class='calendar'>
		<view class='time'>
			<view>
				<text>{{year}}年</text>
				<text>{{month}}月</text>
			</view>
			<view class='text-right'>
				本月已签到
				<text class='t_red'>{{calendarSignDay}}</text>天
			</view>
		</view>
		<view class='weekName'>
			<view class='sunday'>日</view>
			<view class='monday'>一</view>
			<view class='tuesday'>二</view>
			<view class='wednesday'>三</view>
			<view class='thursday'>四</view>
			<view class='friday'>五</view>
			<view class='saturday'>六</view>
		</view>

		<view class='week'>
			<!--填补空格-->
			<view v-for='(item, index) in nbsp' :key="index"></view>
			<view v-for='(item, index) in date-1' style='color:gainsboro;' :key="index">
				<!-- #ifndef APP-PLUS || H5 -->
				<text v-if='item+1==calendarSignData[item+1]' style='color:#e41f19;font-size:22rpx;'>签</text>
				<text v-else=''>{{item+1}}</text>
				<!-- #endif -->
				<!-- #ifdef APP-PLUS || H5 -->
				<text v-if='item==calendarSignData[item]' style='color:#e41f19;font-size:22rpx;'>签</text>
				<text v-else=''>{{item}}</text>
				<!-- #endif -->
			</view>
			<view style='border-bottom: 1px solid #e41f19; padding-bottom:8rpx;'>
				<text v-if='date==calendarSignData[date]' style='color:#e41f19;font-size:22rpx;border-radius: 100%;background-color: ghostwhite'>签</text>
				<text v-else='' style='color:#e41f19;'>{{date}}</text>
			</view>
			<!-- 当天以后的日期只显示数字 -->
			<!-- #ifndef APP-PLUS || H5 -->
			<view v-for='(item, index) in monthDaySize-date' :key="index">{{item + date + 1}}</view>
			<!-- #endif -->
			<!-- #ifdef APP-PLUS || H5 -->
			<view v-for='(item, index) in monthDaySize-date' :key="index">{{item + date}}</view>
			<!-- #endif -->
		</view>
		<view class='calendarSign'>
			<tui-button type="green" shape="circle" v-if='date!=calendarSignData[date]' @click='calendarSign'>签到</tui-button>
			<tui-button type="gray" shape="circle" disabled v-else=''>今日已签到</tui-button>
		</view>
	</view>
</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {
			return {
				nbsp: 0,
				year: '',
				month: '',
				monthDaySize: 30, //当月天数
				calendarSignData: [], //当前月签到的list
				date: 1, //当天的日期 4
				calendarSignDay: 0 //当月签到次数
			}
		},
		onLoad: function() {
			let that = this;
			let mydate = new Date();
			let year = mydate.getFullYear();
			let month = mydate.getMonth() + 1;
			let date = mydate.getDate();
			let day = mydate.getDay();
			let nbsp;
			if ((date - day) <= 0) {
				nbsp = day - date + 1;
			} else {
				nbsp = 7 - ((date - day) % 7) + 1;
			}
			if (nbsp > 7) {
				nbsp = nbsp - 7
			}
			this.year = year
			this.month = month
			this.nbsp = nbsp
			this.date = date

			that.getSignRecord();
		},
		methods: {
			calendarSign: function() {
				let that = this;
				util.request('sign/userSign').then(function(res) {
					if (res.code === 0) {
						if (res.data === 1) {
							util.toast('签到成功');
							that.getSignRecord();
						}
					}
				});
			},
			getSignRecord: function() {
				let that = this;
				util.request('sign/getMonthSign').then(function(res) {
					if (res.code === 0) {
						that.monthDaySize = res.monthDaySize
						that.calendarSignData = res.calendarSignData
						that.calendarSignDay = res.calendarSignDay
					}
				});
			}
		}
	}
</script>

<style>
	.t_red {
		color: #e41f19;
	}

	.t_blue {
		color: royalblue;
	}

	.calendar {
		margin: 0 1vw;
	}

	.time {
		padding: 16rpx 20rpx;
		/* background-color: wheat; */
		display: flex;
	}

	.time view {
		flex: 1;
		font-size: 30rpx;
	}

	.weekName {
		border-bottom: 1px solid lightgrey;
		width: 100%;
		display: flex;
		padding: 16rpx 0;
	}

	.weekName view {
		flex: 1;
		text-align: center;
	}

	.sunday,
	.saturday {
		color: #e41f19;
	}

	.week {
		margin: 2.5vw;
		padding: 2vw;
		border-radius: 10px;
		background: linear-gradient(#74AADA, #94db98);
	}

	.week view {
		width: 14.2%;
		height: 80rpx;
		line-height: 80rpx;
		display: inline-block;
		margin: 20rpx 0;
		text-align: center;
	}

	.week view text {
		width: 100%;
		height: 100%;
		display: inline-block;
	}

	.calendarSign {
		margin: 20rpx;
	}

	.sign-btn {
		width: 50%;
		top: 100rpx;
		color: white;
		background-color: #e41f19;
	}

	.text-right {
		text-align: right;
	}
</style>
