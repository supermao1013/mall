<template>
	<view class="tui-row__box" :class="[isFlex?'tui-row__flex':'', justifyClass,alignClass]"
		:style="{marginTop:marginTop,marginBottom:marginBottom}">
		<slot></slot>
	</view>
</template>

<script>
	export default {
		name: "tui-row",
		props: {
			//是否为flex布局
			isFlex: {
				type: Boolean,
				default: false
			},
			//flex 布局下的水平排列方式 start/end/center/space-around/space-between
			justify: {
				type: String,
				default: 'start'
			},
			//flex 布局下的垂直排列方式	top/middle/bottom
			align: {
				type: String,
				default: 'top'
			},
			marginTop: {
				type: String,
				default: '0'
			},
			marginBottom: {
				type: String,
				default: '0'
			}
		},
		computed: {
			justifyClass() {
				return this.justify !== 'start' ? `tui-row__${this.justify}` : ''
			},
			alignClass() {
				return this.align !== 'top' ? `tui-row__${this.align}` : ''
			}
		}
	}
</script>

<style scoped>
	/* #ifdef MP-WEIXIN || MP-TOUTIAO || MP-QQ */
	:host {
		position: relative;
		box-sizing: border-box;
		width: 100%
	}

	/* #endif */

	.tui-row__box {
		width: 100%;
		position: relative;
		box-sizing: border-box;
		/* #ifdef MP-TOUTIAO || MP-QQ || MP-BAIDU */
		display: block;
		/* #endif */
	}

	.tui-row__box::before,
	.tui-row__box::after {
		display: table;
		content: "";
	}

	.tui-row__box::after {
		clear: both;
	}

	.tui-row__flex {
		/* #ifndef APP-NVUE*/
		display: flex !important;
		/* #endif */

		/* #ifdef APP-NVUE */
		flex-direction: row;
		/* #endif */
	}

	.tui-row__middle {
		align-items: center;
	}

	.tui-row__bottom {
		align-items: flex-end;
	}

	.tui-row__before {
		display: table
	}

	.tui-row__end {
		justify-content: flex-end;
	}

	.tui-row__center {
		justify-content: center;
	}

	.tui-row__space-around {
		justify-content: space-around;
	}

	.tui-row__space-between {
		justify-content: space-between;
	}
</style>
