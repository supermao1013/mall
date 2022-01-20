<template>
	<button
		class="tui-form-button"
		:class="[
			bold ? 'tui-text-bold' : '',
			time && !plain && !link ? 'tui-button__active' : '',
			time && (plain || link) ? 'tui-button__opacity' : '',
			disabled && !disabledBackground ? 'tui-button__opacity' : ''
		]"
		:style="{
			width: width,
			height: height,
			lineHeight: height,
			fontSize: size + 'rpx',
			margin: margin,
			background: disabled && disabledBackground ? disabledBackground : plain || link ? 'transparent' : background,
			borderColor: borderColor ? borderColor : disabled && disabledBackground ? disabledBackground : link ? 'transparent' : background,
			color: disabled && disabledBackground ? disabledColor : color,
			borderRadius: radius
		}"
		:loading="loading"
		:form-type="formType"
		:open-type="openType"
		@getuserinfo="bindgetuserinfo"
		@getphonenumber="bindgetphonenumber"
		@contact="bindcontact"
		@error="binderror"
		:disabled="disabled"
		@touchstart="handleStart"
		@touchend="handleClick"
		@touchcancel="handleEnd"
		@tap="handleTap"
	>
		<slot></slot>
	</button>
</template>

<script>
export default {
	name: 'tuiFormButton',
	// #ifndef MP-QQ
	behaviors: ['wx://form-field-button'],
	// #endif
	props: {
		//按钮背景色
		background: {
			type: String,
			default: '#5677fc'
		},
		//按钮字体颜色
		color: {
			type: String,
			default: '#fff'
		},
		//按钮禁用背景色
		disabledBackground: {
			type: String,
			default: ''
		},
		//按钮禁用字体颜色
		disabledColor: {
			type: String,
			default: ''
		},
		borderColor: {
			type: String,
			default: ''
		},
		// 宽度 rpx或 %
		width: {
			type: String,
			default: '100%'
		},
		//高度 rpx
		height: {
			type: String,
			default: '96rpx'
		},
		//字体大小 rpx
		size: {
			type: Number,
			default: 32
		},
		bold: {
			type: Boolean,
			default: false
		},
		margin: {
			type: String,
			default: '0'
		},
		//圆角
		radius: {
			type: String,
			default: '6rpx'
		},
		plain: {
			type: Boolean,
			default: false
		},
		//link样式，去掉边框背景
		link: {
			type: Boolean,
			default: false
		},
		disabled: {
			type: Boolean,
			default: false
		},
		loading: {
			type: Boolean,
			default: false
		},
		formType: {
			type: String,
			default: ''
		},
		openType: {
			type: String,
			default: ''
		},
		index: {
			type: [Number, String],
			default: 0
		}
	},
	data() {
		return {
			time: 0,
			trigger: false,
			tap: false
		};
	},
	methods: {
		handleStart() {
			if (this.disabled) return;
			this.trigger = false;
			this.tap = true;
			if (new Date().getTime() - this.time <= 150) return;
			this.trigger = true;
			this.time = new Date().getTime();
		},
		handleClick() {
			if (this.disabled || !this.trigger) return;
			this.time = 0;
			this.$emit('click', {
				index: Number(this.index)
			});
		},
		handleTap() {
			// #ifdef H5
			if (this.tap) return;
			this.$emit('click', {
				index: Number(this.index)
			});
			// #endif
		},
		handleEnd() {
			if (this.disabled) return;
			setTimeout(() => {
				this.time = 0;
			}, 150);
		},
		bindgetuserinfo({ detail = {} } = {}) {
			this.$emit('getuserinfo', detail);
		},
		bindcontact({ detail = {} } = {}) {
			this.$emit('contact', detail);
		},
		bindgetphonenumber({ detail = {} } = {}) {
			this.$emit('getphonenumber', detail);
		},
		binderror({ detail = {} } = {}) {
			this.$emit('error', detail);
		}
	}
};
</script>

<style scoped>
.tui-form-button {
	width: 100%;
	position: relative;
	padding-left: 0;
	border: 1rpx solid;
	padding-right: 0;
	overflow: hidden;
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	user-select: none;
}
.tui-form-button::after {
	border: 0;
}
.tui-button__active::after {
	content: ' ';
	background-color: rgba(0, 0, 0, 0.1);
	position: absolute;
	width: 100%;
	height: 100%;
	left: 0;
	right: 0;
	transform: none;
	z-index: 1;
	border-radius: 0;
}
.tui-button__opacity {
	opacity: 0.5;
}

.tui-btn__link {
	border-color: transparent;
	background: transparent;
}
</style>
