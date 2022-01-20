<template>
	<view class="tui-progress__box">
		<view class="tui-progressbar__bg" :style="{ height: width + 'rpx', borderRadius: radius, background: backgroundColor }">
			<view class="tui-progress__bar" :style="{ width: percentage + '%', height: width + 'rpx', background: activeColor }"></view>
		</view>
		<view class="tui-progress__percent" :style="{ width: percentWidth + 'rpx', fontSize: size + 'rpx', color: color }"
		 v-if="showInfo">
			{{ animation ? percentage : percent }}%
		</view>
	</view>
</template>

<script>
	export default {
		name: 'tuiProgress',
		props: {
			//百分比 0-100
			percent: {
				type: [Number, String],
				default: 0
			},
			//右侧是否显示百分比
			showInfo: {
				type: Boolean,
				default: false
			},
			//圆角大小
			radius: {
				type: String,
				default: '8rpx'
			},
			//右侧百分比字体大小 rpx
			size: {
				type: Number,
				default: 28
			},
			//右侧百分比颜色
			color: {
				type: String,
				default: '#333'
			},
			//右侧百分比宽度
			percentWidth: {
				type: Number,
				default: 96
			},
			//百分比是否需要递增动画
			animation: {
				type: Boolean,
				default: true
			},
			//进度条线条宽度 rpx
			width: {
				type: Number,
				default: 8
			},
			//已选进度条颜色,可渐变
			activeColor: {
				type: String,
				default: '#5677fc'
			},
			//未选择的进度条的颜色
			backgroundColor: {
				type: String,
				default: '#EBEBEB'
			},
			//backwards: 动画从头播；forwards：动画从上次结束点接着播
			activeMode: {
				type: String,
				default: 'forwards'
			},
			//进度增加1%所需毫秒数
			duration: {
				type: Number,
				default: 20
			}
		},
		watch: {
			percent(val) {
				this.darwProgress();
			}
		},
		mounted() {
			this.darwProgress();
		},
		data() {
			return {
				percentage: 0,
				timer: null
			};
		},
		methods: {
			darwProgress() {
				clearInterval(this.timer);
				this.timer = null;
				let start = 0;
				if (this.activeMode === 'forwards' && this.percentage < Number(this.percent)) {
					if (Number(this.percent) < this.percentage) {
						//如果传入的百分比比之前的数值小，则重新开始
						this.percentage = 0;
					}
					start = this.percentage;
				}
				let percentage = start;
				let decimalNum = Number(this.percent) - parseInt(this.percent);
				this.percentage = percentage;
				this.timer = setInterval(() => {
					if (percentage + decimalNum >= Number(this.percent)) {
						if (percentage != Number(this.percent)) {
							this.percentage = Number(this.percent)
						}
						clearInterval(this.timer);
						this.timer = null;
						//动画完成事件
						this.$emit('activeend', {});
						return;
					}
					percentage += 1;
					this.percentage = percentage;
				}, this.duration);
			}
		}
	};
</script>

<style scoped>
	.tui-progress__box {
		width: 100%;
		display: flex;
		align-items: center;
	}

	.tui-progressbar__bg {
		width: 100%;
		position: relative;
		overflow: hidden;
		transform: translateZ(0);
	}

	.tui-progress__bar {
		position: absolute;
		left: 0;
		top: 0;
		z-index: 2;
	}

	.tui-progress__percent {
		text-align: center;
	}
</style>
