<template>
	<view class="tui-checkbox__input" :class="{'tui-checkbox__disabled':disabled}"
		:style="{backgroundColor:getBackgroundStyle(val,isCheckMark),border:getBorderStyle(val,isCheckMark),zoom:scaleRatio}"
		@tap.stop="radioChange">
		<view class="tui-check__mark" :style="{borderBottomColor:checkMarkColor,borderRightColor:checkMarkColor}"
			v-if="val"></view>
		<radio class="tui-radio__hidden" :color="color" :disabled="disabled" :value="value" :checked="val"></radio>
	</view>
</template>

<script>
	export default {
		name: "tui-radio",
		options: {
			virtualHost: true
		},
		props: {
			value: {
				type: String,
				default: ''
			},
			checked: {
				type: Boolean,
				default: false
			},
			disabled: {
				type: Boolean,
				default: false
			},
			//radio选中背景颜色
			color: {
				type: String,
				default: '#5677fc'
			},
			//radio未选中时边框颜色
			borderColor: {
				type: String,
				default: '#ccc'
			},
			//是否只展示对号，无边框背景
			isCheckMark: {
				type: Boolean,
				default: false
			},
			//对号颜色
			checkMarkColor: {
				type: String,
				default: '#fff'
			},
			scaleRatio: {
				type: [Number, String],
				default: 1
			}
		},
		created() {
			this.val = this.checked;
			this.group = this.getParent()
			if (this.group) {
				this.group.childrens.push(this);
			}
			this.label = this.getParent('tui-label')
			if (this.label) {
				this.label.childrens.push(this);
			}
		},
		watch: {
			checked(newVal) {
				this.val = newVal;
			},
			val(newVal) {
				if (newVal && this.group) {
					this.group.changeValue(this.value, this);
				}
			}
		},
		data() {
			return {
				val: false
			};
		},
		methods: {
			getBackgroundStyle(val, isCheckMark) {
				let color = val ? this.color : '#fff'
				if (isCheckMark) {
					color = 'transparent'
				}
				return color;
			},
			getBorderStyle(val, isCheckMark) {
				let color = val ? this.color : this.borderColor;
				if (isCheckMark) {
					color = 'transparent'
				}
				return `1px solid ${color}`;
			},
			radioChange(e) {
				if (this.disabled || this.val) return;
				this.val = true;
				this.$emit('change', {
					checked: this.val,
					value: this.value
				})
			},
			getParent(name = 'tui-radio-group') {
				let parent = this.$parent;
				let parentName = parent.$options.name;
				while (parentName !== name) {
					parent = parent.$parent;
					if (!parent) return false;
					parentName = parent.$options.name;
				}
				return parent;
			},
			labelClick() {
				this.radioChange()
			}
		}
	}
</script>

<style scoped>
	.tui-checkbox__input {
		font-size: 0;
		color: rgba(0, 0, 0, 0);
		width: 40rpx;
		height: 40rpx;
		border-radius: 50%;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		box-sizing: border-box;
		overflow: hidden;
		position: relative;
		vertical-align: top;
		flex-shrink: 0;
	}

	.tui-check__mark {
		width: 20rpx;
		height: 40rpx;
		border-bottom: 3px solid #fff;
		border-right: 3px solid #fff;
		transform: rotate(45deg) scale(0.5);
		box-sizing: border-box;
		transform-origin: 54% 48%;
	}

	.tui-radio__hidden {
		display: inline-block;
		position: absolute;
		top: 0;
		left: 0;
		opacity: 0;
		width: 100%;
		height: 100%;
		z-index: 2;
		border: 0 none;
		-webkit-appearance: none;
		-moz-appearance: none;
		appearance: none;
	}

	.tui-checkbox__disabled {
		opacity: 0.6;
	}
</style>
