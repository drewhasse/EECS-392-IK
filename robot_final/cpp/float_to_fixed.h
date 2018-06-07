#pragma once
template <class BaseType, size_t FracDigits>
class fixed_point
{
	const static BaseType factor = 1 << FracDigits;

	BaseType data;

public:
	fixed_point() { *this = 0; }
	fixed_point(double d)
	{
		*this = d; // calls operator=
	}

	fixed_point& operator=(double d)
	{
		data = static_cast<BaseType>(d*factor);
		return *this;
	}

	BaseType raw_data() const
	{
		return data;
	}

	// Other operators can be defined here
};
